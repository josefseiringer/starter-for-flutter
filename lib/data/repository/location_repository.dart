import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/log.dart';

class LocationProvider {
  Uri _buildPtvUri({
    required String lat,
    required String lng,
    required String apiKey,
  }) {
    final proxyBase = dotenv.get('PTV_PROXY_BASE', fallback: '');
    final useProxy = kIsWeb && proxyBase.trim().isNotEmpty;

    if (useProxy) {
      // Ensure proxy base has protocol and no trailing slash
      String cleanBase = proxyBase.trim();
      if (!cleanBase.startsWith('http://') &&
          !cleanBase.startsWith('https://')) {
        cleanBase = 'http://$cleanBase';
      }
      cleanBase = cleanBase.replaceFirst(RegExp(r"/$"), '');

      // Check if using production backend proxy (has /api/geocode endpoint)
      // or development CORS proxy (forwards to PTV path structure)
      final useBackendProxy =
          proxyBase.contains('8088') && !proxyBase.contains('/locations');

      final fullUrl = useBackendProxy
          ? '$cleanBase/api/geocode?lat=$lat&lng=$lng&language=de'
          : '$cleanBase/locations/by-position/$lat/$lng?language=de&apiKey=$apiKey';

      debugPrint('Building proxy URL: $fullUrl');
      return Uri.parse(fullUrl);
    } else {
      // Direct PTV API call (requires CORS configured or mobile platforms)
      return Uri.parse(
          'https://api.myptv.com/geocoding/v1/locations/by-position/$lat/$lng?language=de&apiKey=$apiKey');
    }
  }

  /// Überprüft, ob der Standortdienst aktiviert ist.
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Fragt die Berechtigung für den Standort ab.
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Fordert die Berechtigung für den Standort an.
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Liefert die aktuelle Position des Geräts.
  /// Wirft eine Exception, wenn der Dienst nicht aktiviert ist oder keine Berechtigung vorliegt.
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Standortdienste sind nicht aktiviert.
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        // Berechtigungen sind verweigert.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Berechtigungen sind dauerhaft verweigert.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    // Wenn alles in Ordnung ist, die Position zurückgeben.
    return await Geolocator.getCurrentPosition();
  }

  Future<Log> getAddressLocationLogData(Map map) async {
    Map<String, dynamic> data = {};
    String kPtvApiKey = dotenv.get('PTV_API_KEY');
    var lat = map['lat'].toString();
    var lng = map['lng'].toString();
    final uri = _buildPtvUri(lat: lat, lng: lng, apiKey: kPtvApiKey);
    final client = http.Client();
    try {
      debugPrint('Fetching location data from: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json', 'charset': 'utf-8'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout after 10 seconds');
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response Content-Type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        // Check if response is actually JSON
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          final preview = response.body.length > 200
              ? response.body.substring(0, 200)
              : response.body;
          debugPrint('ERROR: Expected JSON but got: $contentType');
          debugPrint('Response preview: $preview');
          data = {
            'error': 'Invalid response type: $contentType',
            'preview': preview
          };
        } else {
          //Response is successful
          data = json.decode(
            utf8.decode(response.bodyBytes),
          );
        }
      } else {
        final preview = response.body.length > 200
            ? response.body.substring(0, 200)
            : response.body;
        debugPrint('Failed response (${response.statusCode}): $preview');
        data = {
          'error': 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
          'body': preview
        };
      }

      return Log(
        date: _getCurrentDate(),
        status: response.statusCode,
        method: "GET",
        path: uri.path + (uri.hasQuery ? '?${uri.query}' : ''),
        response: data,
      );
    } catch (error) {
      debugPrint('Error fetching location: $error');
      if (kIsWeb) {
        if (error.toString().toLowerCase().contains('failed to fetch')) {
          debugPrint(
              'CORS ISSUE: Use PTV_PROXY_BASE in .env or configure CORS on PTV API');
        } else if (error is FormatException) {
          debugPrint(
              'FORMAT ERROR: API returned non-JSON (likely HTML error page)');
          debugPrint(
              'Check: 1) PTV_API_KEY is valid, 2) Proxy is running, 3) URL is correct');
        }
      }
      return Log(
        date: _getCurrentDate(),
        status: 500,
        method: "GET",
        path: uri.path + (uri.hasQuery ? '?${uri.query}' : ''),
        response: {'error': error.toString()},
      );
    } finally {
      client.close();
    }
  }

  Future<String> getNearbyLocation(Map map) async {
    String kPtvApiKey = dotenv.get('PTV_API_KEY');
    String locationOrt = '?';
    var lat = map['lat'];
    var lng = map['lng'];

    final uri = _buildPtvUri(
        lat: lat.toString(), lng: lng.toString(), apiKey: kPtvApiKey);

    final client = http.Client();
    try {
      debugPrint('Fetching location from: $uri');

      var response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json', 'charset': 'utf-8'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response Content-Type: ${response.headers['content-type']}');

      //Response Data status
      if (response.statusCode == 200) {
        // Check if response is actually JSON
        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          final preview = response.body.length > 200
              ? response.body.substring(0, 200)
              : response.body;
          debugPrint('ERROR: Expected JSON but got: $contentType');
          debugPrint('Response preview: $preview');
          locationOrt = 'Invalid response format';
        } else {
          //Response is successful
          Map<String, dynamic> data = json.decode(
            utf8.decode(response.bodyBytes),
          ); //get response data

          if (data.containsKey('locations') && data['locations'].isNotEmpty) {
            Map<String, dynamic> mapOfAddressfromPosition = data['locations'][0]
                ['address']; //get response address of position
            if (mapOfAddressfromPosition.isNotEmpty) {
              locationOrt =
                  '${mapOfAddressfromPosition['street'].toString()} ${mapOfAddressfromPosition['houseNumber'].toString()}, ${mapOfAddressfromPosition['postalCode'].toString()} ${mapOfAddressfromPosition['city'].toString()}';
            }
          } else {
            debugPrint('No locations found in response');
            locationOrt = 'No location data found';
          }
        }
      } else {
        final preview = response.body.length > 200
            ? response.body.substring(0, 200)
            : response.body;
        debugPrint('Failed to fetch location. Status: ${response.statusCode}');
        debugPrint('Response body: $preview');
        locationOrt = 'HTTP Error ${response.statusCode}';
      }
    } catch (error) {
      debugPrint('Error fetching location: $error');
      locationOrt = 'Failed to fetch location';
    } finally {
      client.close();
    }

    return locationOrt;
  }

  /// Retrieves the current date in the format "MMM dd, HH:mm".
  ///
  /// @return [String] A formatted date.
  String _getCurrentDate() {
    return DateFormat("MMM dd, HH:mm").format(DateTime.now());
  }
}
