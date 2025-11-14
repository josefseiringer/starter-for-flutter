import 'package:flutter/material.dart';

import '../../data/models/list_model.dart';

class MyTankListItem extends StatelessWidget {
  const MyTankListItem({
    super.key,
    required this.item,
  });

  final ListModel item;

  @override
  Widget build(BuildContext context) {
    var whiteWithOpa200 = Colors.orange.withAlpha(200);
    var greyWithOpa150 = Colors.grey.withAlpha(150);
    var headerDate = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    var subText = TextStyle(fontSize: 20, color: Colors.grey.shade800);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: whiteWithOpa200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: greyWithOpa150,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          item.date,
          style: headerDate,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text('Document-ID: ${item.id}'),
            // Text('Benutzer-ID: ${item.userId}'),
            Text(
              'Kilometerstand: ${item.odometer} km',
              style: subText,
            ),
            Text(
              'Liter: ${item.liters} L',
              style: subText,
            ),
            Text(
              'Preis pro Liter: ${item.pricePerLiter} €',
              style: subText,
            ),
            Text(
              'Ort: ${item.location}',
              style: subText,
            ),
            Text(
              'Summe: ${item.szSummePreis} €',
              style: subText,
            ),
          ],
        ),
      ),
    );
  }
}
