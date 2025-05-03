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
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () => _showYearPicker(context, yearController),
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

  void _showYearPicker(
      BuildContext context, TextEditingController yearController) {
    final now = DateTime.now().year;
    final int startYear = 1;
    final initialIndex = int.tryParse(yearController.text) ?? now;
    final scrollIndex = (initialIndex - startYear).clamp(0, now - startYear);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 300,
          child: ListView.builder(
            itemExtent: 48,
            controller: ScrollController(initialScrollOffset: scrollIndex * 48),
            itemCount: now - startYear + 1,
            itemBuilder: (_, index) {
              final year = startYear + index;
              return ListTile(
                title: Center(child: Text('$year年')),
                onTap: () {
                  yearController.text = year.toString();
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
