//data: {
//  userId: 68a36e3a01f5fef9aeb9,
//  date: 2025-11-10,
//  odometer: 9836,
//  liters: 28.63,
//  pricePerLiter: 1.504,
//  location: Tiefenweg 39, 4845 Regau,
//  $id: 69116646000e2bafcd90
//}
class ListModel {
  final String id;
  final String userId;
  final String date;
  final int odometer;
  final double liters;
  final double pricePerLiter;
  final String location;
  int? mnIndexCount;
  String? szSummePreis;

  ListModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.odometer,
    required this.liters,
    required this.pricePerLiter,
    required this.location,
  }):szSummePreis = (liters != 0.0 && pricePerLiter != 0.0)
        ? (liters * pricePerLiter).toStringAsFixed(2)
        : null;

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['\$id'] ?? '',
      userId: map['userId'] ?? '',
      date: map['date'] ?? '',
      odometer:
          map['odometer'] != null ? int.parse(map['odometer'].toString()) : 0,
      liters: map['liters'] != null
          ? double.parse(
              (double.parse(map['liters'].toString())).toStringAsFixed(2))
          : 0.00,
      pricePerLiter: map['pricePerLiter'] != null
          ? double.parse((double.parse(map['pricePerLiter'].toString()))
              .toStringAsFixed(3))
          : 0.000,
      location: map['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '\$id': id,
      'userId': userId,
      'date': date,
      'odometer': odometer,
      'liters': liters,
      'pricePerLiter': pricePerLiter,
      'location': location,
    };
  }
}
