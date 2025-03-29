import 'package:fancale/add_anniversary/add_anniversary.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAnniversaryButton extends StatelessWidget {
  const AddAnniversaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Calender>();

    return IconButton(
        onPressed: () async {
          await showDialog<String>(
            context: context,
            builder: (context) =>
                AddAnniversary(selectedDay: model.selectedDay),
          );
        },
        icon: Row(
          mainAxisSize: MainAxisSize.min, // 横幅をアイコンの幅に合わせる
          children: [
            const Icon(Icons.add, size: 20),
            const SizedBox(width: 2),
            const Icon(Icons.cake, size: 24),
          ],
        ) // 記念日っぽいアイコンに変更
        );
  }
}
