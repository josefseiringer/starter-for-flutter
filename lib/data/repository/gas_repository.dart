import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/log.dart';
import '../../data/repository/location_repository.dart';

class GasRepository {
  final LocationProvider _locationProvider = LocationProvider();

  Future<Log> switchGas(String s) async {
    String pingPath = '';
    try {
      var position = await _locationProvider.getCurrentPosition();
      if (position.latitude > 0 == true && position.longitude > 0 == true) {
        var latitude = position.latitude;
        var longitude = position.longitude;
        var fuelType = s; // 'DIE' or 'SUP'
        var gasUrl = dotenv.env['E_CONTROL_LINK'];
        pingPath =
            '$gasUrl?latitude=$latitude&longitude=$longitude&fuelType=$fuelType&includeClosed=false';
        // Implementation for switching gas type in the repository
        var uri = Uri.parse(pingPath);
        var response = await http.get(uri);
        var responseBody = response.bodyBytes.isNotEmpty
            ? utf8.decode(response.bodyBytes)
            : 'No content';
        
        // Parse JSON response
        Map<String, dynamic> parsedResponse = {};
        try {
          if (responseBody != 'No content') {
            parsedResponse = {'body': jsonDecode(responseBody)};
          } else {
            parsedResponse = {'body': []};
          }
        } catch (e) {
          print('Error parsing JSON: $e');
          parsedResponse = {'error': 'Invalid JSON response'};
        }
        
        return Log(
          date: _getCurrentDate(),
          status: 200,
          method: "GET",
          path: pingPath,
          response: parsedResponse,
        );
      } else {
        return Log(
          date: _getCurrentDate(),
          status: 400,
          method: "GET",
          path: pingPath,
          response: {'error': 'Invalid location data'},
        );
      }
    } catch (error) {
      print('Error in switchGas: $error' );
      return Log(
        date: _getCurrentDate(),
        status: 500,
        method: "GET",
        path: pingPath,
        response: {'error': error.toString()},
      );
    }
  }

  /// Retrieves the current date in the format "MMM dd, HH:mm".
  ///
  /// @return [String] A formatted date.
  String _getCurrentDate() {
    return DateFormat("MMM dd, HH:mm").format(DateTime.now());
  }
}
