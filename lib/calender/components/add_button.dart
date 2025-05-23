import 'package:fancale/add_calender_memo/add_calender_memo_page.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Calender>();

    return IconButton(
        onPressed: () async {
          await showDialog<String>(
              context: context,
              builder: (context) =>
                  AddClenderMemo(selectedDay: model.selectedDay));
        },
        icon: Row(
          mainAxisSize: MainAxisSize.min, // 横幅をアイコンの幅に合わせる
          children: [
            const Icon(Icons.add, size: 18),
            const SizedBox(width: 2),
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 2),
            const Text('予定')
          ],
        ));
  }
}
