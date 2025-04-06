import 'package:fancale/add_anniversary/add_anniversary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAnniversary extends StatelessWidget {
  final DateTime? selectedDay;
  const AddAnniversary({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController yearController =
        TextEditingController(text: selectedDay?.year.toString());

    return ChangeNotifierProvider(
      create: (_) => AddAnniversaryModel(), // 変更したモデルを使う
      child: AlertDialog(
        title: const Text('記念日を入力してください'), // 記念日メモに変更
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '年',
                      hintText: '手入力 or ▼ボタンで選択',
                    ),
                  ),
                ),
                PopupMenuButton<int>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    yearController.text = value.toString();
                  },
                  itemBuilder: (context) {
                    return List.generate(30, (index) {
                      final year = DateTime.now().year - index;
                      return PopupMenuItem(
                        value: year,
                        child: Text('$year年'),
                      );
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    yearController.text = ''; // 年を空にする
                  },
                  child: const Text('年を指定しない'),
                ),
              ],
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル')),
          Consumer<AddAnniversaryModel>(builder: (context, model, child) {
            return TextButton(
                onPressed: () async {
                  try {
                    await model.addAnniversary(selectedDay, controller.text,
                        yearController.text); // 変更したメソッド名
                  } catch (e) {
                    final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'));
          })
        ],
      ),
    );
  }
}
