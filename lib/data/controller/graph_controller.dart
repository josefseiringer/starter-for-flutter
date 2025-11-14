import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/extensions/static_helper.dart';
import '../models/chart_model.dart';
import '../models/list_model.dart';
import '../repository/appwrite_repository.dart';

class GraphController extends GetxController {
    //AppWrite API-REST get Data
  final AppwriteRepository _authRepository = AppwriteRepository();

  final szRxUserId = 'NoUser'.obs;
  final szBarTitle = ''.obs;
  final listYearModel = <YearModel>[].obs;
  late List<ListModel> tankListOriginal;
  final tankList = <ListModel>[].obs;
  final yearValue = DateTime.now().year.obs;
  final blIsLoading = false.obs;
  final dataPointsEuro = <double>[].obs;
  final dataPointsGasoline = <double>[].obs;
  final pointsEuro = <PricePoints>[].obs;
  final pointsGasoline = <PricePoints>[].obs;
  final sumListData = <SumDataModel>[].obs;
  final mnCurrentAveragePerLiter = 0.00.obs;
  final pointsPerLiter = <PricePoints>[].obs;
  final dataPointsPerLiter = <double>[].obs;
  final mnCurrentSummEuroYear = 0.0.obs;
  final mnCurrentSummLiterYear = 0.0.obs;

  @override
  void onInit() {
    _getTankList();
    super.onInit();
  }

  @override
  void onClose() {}

  void _getTankList() async {
    blIsLoading(true);
    bool isErrorByLoading = false;
    String message = '';
    try {
      await _authRepository.listDocuments()
          .then((getLog) {
        if (getLog.response.isEmpty) {
          blIsLoading(false);
          isErrorByLoading = true;
          message = 'Leere Liste keine Daten vorhanden';
          return;
        }
        tankList.clear();
        var data = getLog.response;
        List d = data['documents'].toList();
        tankList.value =
            d.map((e) => ListModel.fromMap(e['data'])).toList();
        tankList.sort((a, b) {
          final DateTime dateA = DateTime.parse(a.date);
          final DateTime dateB = DateTime.parse(b.date);
          return dateB.compareTo(dateA);
        });
        message = 'Liste wurde erfolgreich geladen';
      }).catchError((error) {
        blIsLoading(true);
        isErrorByLoading = true;
        if (error is AppwriteException) {
          message = error.message!;
        } else {
          message = 'Uuups da ist was schief gelaufen';
        }
      });
    } catch (e) {
      blIsLoading(true);
      isErrorByLoading = true;
      message = 'Fehler beim Laden der Tankliste';
      print('Error fetching tank list: $e');
    }
    String title = isErrorByLoading ? 'Fehler' : 'Erfolg';
    Get.snackbar(
      title,
      message,
      backgroundColor: isErrorByLoading ? Colors.red : Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
    tankListOriginal = tankList;
    update();
    setListMapYear();
    getTankListPerYear();
  }

  List<String> getHeadDescription() {
    List<String> localListString = [];
    tankList.sort((a, b) {
      final DateTime dateA = DateTime.parse(a.date);
      final DateTime dateB = DateTime.parse(b.date);
      return dateB.compareTo(dateA);
    });
    if (tankList.isNotEmpty) {
      for (var benzinItem in tankList) {
        String szDay = '';
        var dateDay = DateTime.parse(benzinItem.date);
        if (dateDay.day <= 9) {
          szDay = '0${dateDay.day}';
        } else {
          szDay = '${dateDay.day}';
        }
        String szMonth = '';
        if (dateDay.month <= 9) {
          szMonth = '0${dateDay.month}';
        } else {
          szMonth = '${dateDay.month}';
        }
        String szData = '$szDay$szMonth';
        localListString.add(szData);
      }
    }
    update();
    return localListString;
  }

  void setListMapYear() {
    int year = 2022;
    for (var i = year; i <= DateTime.now().year; i++) {
      listYearModel.add(YearModel('Jahr $year', year));
      year = year + 1;
    }
    update();
  }

  void getTankListPerYear() {
    blIsLoading.value = true;
    tankList
        .where((e) => DateTime.parse(e.date).year == yearValue.value)
        .toList();
    getDataPointsForGraph();
    getMonthListData();
    blIsLoading.value = false;
    update();
  }

  void getDataPointsForGraph() {
    //daten ermitteln für Jahr xxxx
    //debugPrint('${yearValue.value}');
    List<double> mnDataPointsEuro = [];
    List<double> mnDataPointsGasoline = [];
    // 08.08.23 Mod. add Price per Liter
    List<double> mnDataPointsPerLiter = [];
    var mnSummPerLiter = 0.0;
    var mnTankListCount = tankList.length;
    for (var item in tankList) {
      var mnLiterGesamt = item.liters;
      var mnEuroGesamt =
          item.liters * item.pricePerLiter;
      var mnPerLiter = item.pricePerLiter;
      mnDataPointsEuro.add(mnEuroGesamt);
      mnDataPointsGasoline.add(mnLiterGesamt);
      mnDataPointsPerLiter.add(mnPerLiter.toPrecision(2));
      mnSummPerLiter += mnPerLiter;
    }
    if (mnSummPerLiter > 0 && mnTankListCount > 0) {
      mnCurrentAveragePerLiter.value =
          (mnSummPerLiter / mnTankListCount).toPrecision(2);
    }
    dataPointsEuro.value = mnDataPointsEuro;
    dataPointsGasoline.value = mnDataPointsGasoline;
    dataPointsPerLiter.value = mnDataPointsPerLiter;
    getPricePointsEuro();
    getPricePointsGasoline();
    getPricePointsPerLiter();
    update();
  }

  void getMonthListData() {
    if (tankList.isNotEmpty) {
      sumListData.clear();
      List<ListModel> tankListPerYear = tankList;
      List<dynamic> monthList = StaticHelper.listMonth;
      for (var monthMap in monthList) {
        var szMonth = monthMap['month'].toString();
        var szValueMonth = monthMap['value'];
        var result = StaticHelper.staticListGetDaysInBetween(
          tankListPerYear,
          szValueMonth,
          yearValue.value,
        );
        var tankListPerMon = result as List<ListModel>;
        if (tankListPerMon.isNotEmpty) {
          SumDataModel sumDataModel = SumDataModel('', '', '', 0);
          sumDataModel.szMonth = szMonth;
          sumDataModel.mnTankungen = tankListPerMon.length;
          double mnSumEuro = 0.0;
          double mnSumBenzin = 0.0;
          for (var tankungModel in tankListPerMon) {
            var mnEuroGesamt = tankungModel.liters * tankungModel.pricePerLiter;
            mnSumBenzin += tankungModel.liters;
            mnSumEuro += mnEuroGesamt;
          }
          sumDataModel.szVerbrauch = mnSumBenzin.toStringAsFixed(2);
          sumDataModel.szSumme = mnSumEuro.toStringAsFixed(2);
          sumListData.add(sumDataModel);
        }
      }
      _currentSumForYear();
    }
  }

  void getPricePointsEuro() {
    var listPoints = dataPointsEuro.indexed
        .map((e) => PricePoints(x: e.$1.toDouble(), y: e.$2))
        .toList();
    pointsEuro.value = listPoints;
    update();
  }

  void getPricePointsGasoline() {
    var listPoints = dataPointsGasoline.indexed
        .map((e) => PricePoints(x: e.$1.toDouble(), y: e.$2))
        .toList();
    pointsGasoline.value = listPoints;
    update();
  }

  void getPricePointsPerLiter() {
    var listPoints = dataPointsPerLiter.indexed
        .map((e) => PricePoints(x: e.$1.toDouble(), y: e.$2))
        .toList();
    pointsPerLiter.value = listPoints;
    update();
  }

  void _currentSumForYear() {
    mnCurrentSummEuroYear.value = 0.0;
    mnCurrentSummLiterYear.value = 0.0;
    if (sumListData.isNotEmpty) {
      for (var rxListItem in sumListData) {
        mnCurrentSummEuroYear.value =
            mnCurrentSummEuroYear.value + double.parse(rxListItem.szSumme!);
        mnCurrentSummLiterYear.value = mnCurrentSummLiterYear.value +
            double.parse(rxListItem.szVerbrauch!);
      }
    }
    update();
  }
}
