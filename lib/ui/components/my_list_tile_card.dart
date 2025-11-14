import 'package:flutter/material.dart';

import '../../data/controller/graph_controller.dart';

final kTextStyle = TextStyle(fontSize: 20, color: Colors.grey.shade100);
final kTextStyleSub = TextStyle(fontSize: 16, color: Colors.grey.shade400);

class MyListTileCard extends StatelessWidget {
  const MyListTileCard({
    super.key,
    required this.graphCtrl,
    required this.index,
  });

  final GraphController graphCtrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.grey.shade800,
      color: Colors.blueGrey.shade700,
      child: ListTile(
        title: Text(
          '${graphCtrl.sumListData[index].szMonth}',
          style: kTextStyle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monatsausgaben: ${graphCtrl.sumListData[index].szSumme} €',
              style: kTextStyleSub,
            ),
            Text(
              'Monatsverbrauch: ${graphCtrl.sumListData[index].szVerbrauch} L',
              style: kTextStyleSub,
            ),
            Text(
              'Tankungen: ${graphCtrl.sumListData[index].mnTankungen}',
              style: kTextStyleSub,
            ),
          ],
        ),
      ),
    );
  }
}
