import 'package:fancale/edit_calender_memo/edit_calender_memo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditCalenderMemo extends StatelessWidget {
  final DateTime? selectedDay;
  final String initialText;
  final String id;

  const EditCalenderMemo({
    super.key,
    required this.selectedDay,
    required this.initialText,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: initialText);

    return ChangeNotifierProvider(
      create: (_) => EditCalenderMemoModel(),
      child: AlertDialog(
        title: const Text('予定を編集してください'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
          Consumer<EditCalenderMemoModel>(builder: (context, model, child) {
            return TextButton(
              onPressed: () async {
                try {
                  await model.updateMemo(id, selectedDay, controller.text);
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
          }),
        ],
      ),
    );
  }
}
