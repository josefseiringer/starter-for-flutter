import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/cart_desc.dart';
import '../components/chart_lines.dart';
import '../components/chart_single_lines.dart';
import '../components/my_list_tile_card.dart';
import '../../data/controller/graph_controller.dart';
import '../../ui/pages/list_view.dart';

final kColorEuroChart = Colors.red.shade500;
final kColorBenzinChart = Colors.yellow.shade500;
final kColorPerLiterChart = Colors.yellow.shade800;
final kChartDescriptionFontStyle = TextStyle(
  color: Colors.grey.shade900,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
final kInputDecorationDropDownMenueYear = InputDecoration(
  prefixIcon: Icon(Icons.date_range),
  hintText: 'Jahresauswahl',
  filled: true,
  fillColor: Colors.white,
  errorStyle: TextStyle(color: Colors.yellow),
);

class GraphPage extends GetView<GraphController> {
  static const namedRoute = '/graph-statistic-page';
  const GraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size queryDisplaySize = MediaQuery.of(context).size;
    var graphCtrl = controller;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 50,
                      child: IconButton(
                        onPressed: () => Get.offAndToNamed(ListPage.namedRoute),
                        icon: const Icon(Icons.list),
                      ),
                    ),
                    SizedBox(
                      width: queryDisplaySize.width - 70,
                      child: Obx(() => _displayDropDownMenue(graphCtrl)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Obx(
                () => Container(
                  color: Colors.grey.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ChartDescription(
                        backgroundColor: kColorEuroChart,
                        mnWidth: double.infinity,
                        szDescText: '€ Summe/J',
                        szCurrentSumData:
                            graphCtrl.mnCurrentSummEuroYear.toStringAsFixed(2),
                      ),
                      ChartDescription(
                        backgroundColor: kColorBenzinChart,
                        mnWidth: double.infinity,
                        szDescText: 'L Verbrauch/J',
                        szCurrentSumData:
                            graphCtrl.mnCurrentSummLiterYear.toStringAsFixed(2),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              LineChartLines(
                firstLineColor: kColorEuroChart,
                secondLineColor: kColorBenzinChart,
              ),
              Obx(
                () => graphCtrl.blIsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.cyan),
                      )
                    : const SizedBox.shrink(),
              ),
              Divider(color: Colors.grey.shade800),
              Obx(
                () => Container(
                  color: Colors.pink.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ChartDescription(
                    backgroundColor: kColorPerLiterChart,
                    mnWidth: queryDisplaySize.width,
                    szDescText: '€/L Durchs.',
                    szCurrentSumData: graphCtrl.mnCurrentAveragePerLiter.value
                        .toStringAsFixed(2),
                  ),
                ),
              ),
              Divider(color: Colors.grey.shade800),
              LineChartSingleLine(singleLineColor: kColorPerLiterChart),
              Divider(
                color: Colors.grey.shade800,
                thickness: 2.0,
              ),
              Obx(
                () => graphCtrl.blIsLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Colors.yellow.shade700),
                      )
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => Expanded(
                  child: ListView.builder(
                    itemCount: graphCtrl.sumListData.length,
                    itemBuilder: (context, index) {
                      return MyListTileCard(graphCtrl: graphCtrl, index: index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField _displayDropDownMenue(GraphController controller) {
    var graphCtrl = controller;
    var list = graphCtrl.listYearModel;
    var valueOfList = graphCtrl.yearValue.value;
    return DropdownButtonFormField(
      decoration: kInputDecorationDropDownMenueYear,
      items: list.map((map) {
        return DropdownMenuItem(
          value: map.mnYear,
          child: Text(map.szDescription),
        );
      }).toList(),
      isDense: true,
      isExpanded: true,
      initialValue: valueOfList,
      onChanged: ((value) {
        valueOfList = value;
        graphCtrl.yearValue.value = valueOfList;
        if (graphCtrl.yearValue.value > 0) {
          graphCtrl.getTankListPerYear();
        }
      }),
    );
  }
}
