import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:fancale/edit_anniversary/edit_anniversary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnniversaryListItem extends StatelessWidget {
  final DocumentSnapshot document;

  const AnniversaryListItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final model = context.read<Calender>();
    final date = (document['date'] as Timestamp).toDate();

    return ListTile(
      title: Text('🎂 ${document["title"]}'),
      subtitle: Text('${date.month}/${date.day}'),
      trailing: PopupMenuButton<String>(
        onSelected: (value) async {
          if (value == 'delete') {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('削除の確認'),
                content: const Text('この記念日を削除してもよろしいですか？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('キャンセル'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('削除する'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              await model.deleteAnniversary(document.id);
            }
          }
          if (value == 'edit') {
            await showDialog<String>(
              context: context,
              builder: (context) => EditAnniversary(
                selectedDay: model.selectedDay,
                id: document.id,
                title: document["title"],
                year: date.year == 9999 ? '' : date.year.toString(),
              ),
            );
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('編集'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('削除'),
          ),
        ],
      ),
    );
  }
}
