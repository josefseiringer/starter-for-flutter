import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/list_model.dart';

class StaticHelper {
  static double sumMonatEuro = 0.0;
  static double sumMonatLiter = 0.0;
  static List staticSearchList = [];


  static List listMonth = [
    {'month': 'Jänner', 'value': '01'},
    {'month': 'Februar', 'value': '02'},
    {'month': 'März', 'value': '03'},
    {'month': 'April', 'value': '04'},
    {'month': 'Mai', 'value': '05'},
    {'month': 'Juni', 'value': '06'},
    {'month': 'Juli', 'value': '07'},
    {'month': 'August', 'value': '08'},
    {'month': 'September', 'value': '09'},
    {'month': 'Oktober', 'value': '10'},
    {'month': 'November', 'value': '11'},
    {'month': 'Dezember', 'value': '12'},
  ];

  static List staticListGetDaysInBetween(
    List<ListModel> list,
    String monthValue,
    int year,
  ) {
    List<ListModel> searchList = [];
    List<DateTime> days = [];
    var dateYear = year;
    var auswahlMonat = int.parse(monthValue);
    var startDate = DateTime(dateYear, auswahlMonat, 1);
    var endDate = DateTime(dateYear, auswahlMonat + 1, 0);
    //List of Days
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(DateTime(startDate.year, startDate.month, startDate.day + i));
    }
    sumMonatEuro = 0.0;
    sumMonatLiter = 0.0;
    int entryCounter = 0;
    for (var day in days) {
      for (ListModel model in list) {
        int milliSecDate = (DateTime.parse(model.date)).microsecondsSinceEpoch;
        if (milliSecDate == day.microsecondsSinceEpoch) {
          entryCounter = entryCounter + 1;
          model.mnIndexCount = entryCounter;
          searchList.add(model);
          var mnEuroGesamt = model.liters * model.pricePerLiter;
          sumMonatEuro += mnEuroGesamt;
          sumMonatLiter += model.liters;
        }
      }
    }
    searchList.sort((a, b) {
      final DateTime dateA = DateTime.parse(a.date);
      final DateTime dateB = DateTime.parse(b.date);
      return dateB.compareTo(dateA);
    });
    return staticSearchList = searchList;
  }

  static getMySnackeBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

}
