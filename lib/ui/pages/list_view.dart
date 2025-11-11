import 'package:appwrite_flutter_tank_app_101125/data/models/list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/list_controller.dart';
import '../components/my_tank_list_item.dart';

class ListPage extends GetView<ListController> {
  static const String namedRoute = '/list-page';
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var listCtrl = controller;
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => listCtrl.onBackPressed(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: Obx(
              () => Text('Tankstopps, ${listCtrl.userName.value}'),
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => listCtrl.addItem(),
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
          body: Obx(() {
            return listCtrl.isloading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/mazdaCX60.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(18),
                      itemCount: listCtrl.listTankModel.length,
                      itemBuilder: (context, index) {
                        var item = listCtrl.listTankModel[index];
                        return Dismissible(
                          key: Key(item.id),
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 24),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              listCtrl.editItem(item);
                              return false; // Nicht löschen, nur editieren
                            } else if (direction ==  DismissDirection.endToStart) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => _alertDialog(ctx),
                              );
                              if (confirm == true) {
                                listCtrl.deleteItem(item);
                                return true;
                              }
                              return false;
                            }
                            return false;
                          },
                          child: MyTankListItem(item: item),
                        );
                      },
                    ),
                  );
          }),
        ),
      ),
    );
  }

  AlertDialog _alertDialog(BuildContext ctx) {
    return AlertDialog(
      title: const Text('Löschen?'),
      content: const Text('Möchtest du diesen Eintrag wirklich löschen?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Löschen'),
        ),
      ],
    );
  }
}
