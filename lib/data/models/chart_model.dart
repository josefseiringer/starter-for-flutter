class ChartData {
  final double dateInMilliseconds;
  final double liters;
  final double pricePerLiter;
  final double totalPrice;

  ChartData({
    required this.dateInMilliseconds,
    required this.liters,
    required this.pricePerLiter,
    required this.totalPrice,
  });
}

class PricePoints {
  final double x;
  final double y;

  PricePoints({required this.x, required this.y});
}

class SumDataModel {
  late String? szMonth;
  late String? szSumme;
  late String? szVerbrauch;
  late int? mnTankungen;

  SumDataModel(this.szMonth, this.szSumme, this.szVerbrauch, this.mnTankungen);
}

class YearModel {
  final String szDescription;
  final int mnYear;

  YearModel(this.szDescription, this.mnYear);
}
