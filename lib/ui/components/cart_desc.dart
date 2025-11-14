import 'package:flutter/material.dart';

final kChartDescriptionFontStyle = TextStyle(
  color: Colors.grey.shade900,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final kTextStyle = TextStyle(fontSize: 20, color: Colors.grey.shade100);

class ChartDescription extends StatelessWidget {
  final double mnWidth;
  final Color backgroundColor;
  final String szDescText;
  final String szCurrentSumData;
  const ChartDescription({
    super.key,
    required this.mnWidth,
    required this.backgroundColor,
    required this.szDescText,
    required this.szCurrentSumData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mnWidth,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15),
            ),
            width: 70,
            height: 20,
            child: Center(
              child: Text(szCurrentSumData, style: kChartDescriptionFontStyle),
            ),
          ),
          const SizedBox(width: 10),
          Text(szDescText, style: kTextStyle),
        ],
      ),
    );
  }
}
