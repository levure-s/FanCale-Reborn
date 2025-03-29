import 'package:fancale/add_anniversary/add_anniversary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAnniversary extends StatelessWidget {
  final DateTime? selectedDay;
  const AddAnniversary({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return ChangeNotifierProvider(
      create: (_) => AddAnniversaryModel(), // 変更したモデルを使う
      child: AlertDialog(
        title: const Text('記念日を入力してください'), // 記念日メモに変更
        content: TextField(controller: controller),
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
                    await model.addAnniversary(
                        selectedDay, controller.text); // 変更したメソッド名
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
