import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:euexia/app/modules/tips/controllers/tips_controller.dart';
import 'package:euexia/app/data/models/consejos.dart';

class TipsView extends StatelessWidget {
  TipsView({super.key});

  final TipsController tipsController = Get.find<TipsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tips'),
      ),
      body: Obx(() {
        if (tipsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color azul para el botón de añadir
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      _showAddModal(context);
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Descripción')),
                        DataColumn(label: Text('Editar')),
                        DataColumn(label: Text('Eliminar')),
                      ],
                      rows: tipsController.tips.map((tip) {
                        return DataRow(cells: [
                          DataCell(Text(tip.idconsejo.toString())),
                          DataCell(Text(tip.descripcion)),
                          DataCell(
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Color azul para el botón de editar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                _showEditModal(context, tip);
                              },
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                          DataCell(
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Color rojo para el botón de eliminar
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () {
                                _showDeleteModal(context, tip);
                              },
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  void _showAddModal(BuildContext context) {
    final TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir Tip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Acción de añadir
                final newTip = Consejos(idconsejo: tipsController.tips.length + 1, descripcion: descripcionController.text);
                await tipsController.addTip(newTip);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, Consejos tip) {
    final TextEditingController descripcionController = TextEditingController(text: tip.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tip'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: TextEditingController(text: tip.idconsejo.toString()),
                decoration: const InputDecoration(labelText: 'ID'),
                enabled: false,
              ),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Acción de guardar
                tip.descripcion = descripcionController.text;
                await tipsController.updateTip(tip);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteModal(BuildContext context, Consejos tip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Tip'),
          content: const Text('¿Estás seguro que quieres eliminar este tip?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Color rojo para el botón de eliminar
              ),
              onPressed: () async {
                // Acción de eliminar
                await tipsController.deleteTip(tip.idconsejo);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
