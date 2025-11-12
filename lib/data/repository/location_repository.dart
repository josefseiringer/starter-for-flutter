import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/log.dart';

class LocationProvider {
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
    // Hier kannst du die Logik hinzufügen, um den Standort zu verwenden, z.B.
    String ptvGeoLink =
        'https://api.myptv.com/geocoding/v1/locations/by-position/$lat/$lng?language=de&apiKey=$kPtvApiKey';
    final client = http.Client();
    try {
      final response = await client.get(
        Uri.parse(ptvGeoLink),
        headers: {'Content-Type': 'application/json', 'charset': 'utf-8'},
      );
      if (response.statusCode == 200) {
        //Response is succsessful
        data = json.decode(
          utf8.decode(response.bodyBytes),
        );
      }
      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: "GET",
        path: "locations/by-position/$lat/$lng?language=de&apiKey=$kPtvApiKey",
        response: data,
      );
    } catch (error) {
      print('Error fetching location data: $error');
      return Log(
        date: _getCurrentDate(),
        status: 500,
        method: "GET",
        path: "locations/by-position/$lat/$lng?language=de&apiKey=$kPtvApiKey",
        response: {'error': error.toString()},
      );
    }finally {
      client.close();
    }
  }

  Future<String> getNearbyLocation(Map map) async {
    String kPtvApiKey = dotenv.get('PTV_API_KEY');
    String locationOrt = '?';
    var lat = map['lat'];
    var lng = map['lng'];
    // Hier kannst du die Logik hinzufügen, um den Standort zu verwenden, z.B.
    String ptvGeoLink =
        'https://api.myptv.com/geocoding/v1/locations/by-position/$lat/$lng?language=de&apiKey=$kPtvApiKey';
    final client = http.Client();
    var response = await client.get(
      Uri.parse(ptvGeoLink),
      headers: {'Content-Type': 'application/json', 'charset': 'utf-8'},
    );
    //Response Data status
    if (response.statusCode == 200) {
      //Response is succsessful
      Map<String, dynamic> data = json.decode(
        utf8.decode(response.bodyBytes),
      ); //get response data
      Map<String, dynamic> mapOfAddressfromPosition =
          data['locations'][0]['address']; //get response address of position
      if (mapOfAddressfromPosition.isNotEmpty) {
        locationOrt =
            '${mapOfAddressfromPosition['street'].toString()} ${mapOfAddressfromPosition['houseNumber'].toString()}, ${mapOfAddressfromPosition['postalCode'].toString()} ${mapOfAddressfromPosition['city'].toString()}';
      }
    } else {
      debugPrint(response.statusCode.toString());
    }
    client.close();

    return locationOrt;
  }

  /// Retrieves the current date in the format "MMM dd, HH:mm".
  ///
  /// @return [String] A formatted date.
  String _getCurrentDate() {
    return DateFormat("MMM dd, HH:mm").format(DateTime.now());
  }
}
