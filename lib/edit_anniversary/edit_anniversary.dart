import 'package:fancale/edit_anniversary/edit_anniversary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAnniversary extends StatelessWidget {
  final DateTime? selectedDay;
  final String title; // 記念日のタイトル
  final String year; // 記念日の年
  final String id; // 記念日のID
  const EditAnniversary({
    super.key,
    required this.selectedDay,
    required this.title,
    required this.year,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: title);
    final TextEditingController yearController =
        TextEditingController(text: year);

    return ChangeNotifierProvider(
      create: (_) => EditAnniversaryModel(), // 編集用でも同じモデルを使う
      child: AlertDialog(
        title: const Text('記念日を編集してください'),
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
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
          Consumer<EditAnniversaryModel>(
            builder: (context, model, child) {
              return TextButton(
                onPressed: () async {
                  try {
                    await model.updateAnniversary(
                      id, // 記念日ID
                      selectedDay,
                      controller.text, // 新しいタイトル
                      yearController.text, // 新しい年
                    );
                  } catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              );
            },
          ),
        ],
      ),
    );
  }
}
