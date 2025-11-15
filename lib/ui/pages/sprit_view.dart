import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/sprit_controller.dart';

class SpritPage extends GetView<SpritController> {
  static const String namedRoute = '/sprit-page';

  const SpritPage({super.key});

  @override
  Widget build(BuildContext context) {
    var spritCtrl = controller;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => spritCtrl.onBackPressed(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Obx(
              () => Text(spritCtrl.headNameFuel.value),
            ),
            centerTitle: true,
          ),
          body: Container(
              padding: const EdgeInsets.only(
                  top: 0, left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _switchDieSup(),
                  _listSpritStopsTop5(),
                ],
              )),
        ),
      ),
    );
  }

  // List for Top 5 Sprit Stops
  Expanded _listSpritStopsTop5() {
    var spritCtrl = controller;
    return Expanded(
      child: Obx(
        () => spritCtrl.isloading.value == false ? ListView.builder(
          itemCount: spritCtrl.listEControl.length,
          itemBuilder: (context, index) {
            var eControl = spritCtrl.listEControl[index];
            var price = eControl.prices.isNotEmpty
                ? eControl.prices[0].amount.toStringAsFixed(3)
                : 'N/A';
            return Card(
              child: ListTile(
                leading: const Icon(Icons.local_gas_station),
                title: Text(eControl.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(eControl.location.address),
                    Text('${eControl.location.postalCode} ${eControl.location.city}'),
                    Text.rich(
                      TextSpan(
                        text: spritCtrl.selectedFuel.value == 'DIE' ? 'Diesel Preis: ' : 'Super Preis: ',
                        children: [
                          TextSpan(
                            text: '$price €',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.navigation),
                onTap: () {
                  // Open navigation to detail page
                  spritCtrl.goToMap(eControl);
                },
              ),
            );
          },
        ): CircularProgressIndicator(),
      ),
    );
  }

  // Switch Button DIE / SUP
  Row _switchDieSup() {
    var spritCtrl = controller;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => spritCtrl.switchGas('DIE'),
          child: Container(
            alignment: Alignment.center,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'DIE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Text(
          'FUEL TYPE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => spritCtrl.switchGas('SUP'),
          child: Container(
            alignment: Alignment.center,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'SUP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
