import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:fancale/edit_calender_memo/edit_calender_memo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoListItem extends StatelessWidget {
  final DocumentSnapshot document;

  const MemoListItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final model = context.read<Calender>();

    return Dismissible(
      key: Key(document.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteDialog(context);
      },
      onDismissed: (direction) async {
        await model.deleteMemo(document.id);
      },
      child: ListTile(
        title: Text(document['memo']),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'delete') {
              final confirm = await _showDeleteDialog(context);
              if (confirm == true) {
                await model.deleteMemo(document.id);
              }
            }
            if (value == 'edit') {
              await showDialog<String>(
                context: context,
                builder: (context) => EditCalenderMemo(
                  selectedDay: model.selectedDay,
                  id: document.id,
                  initialText: document['memo'],
                ),
              );
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'edit',
              child: Text('編集'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('削除'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('削除の確認'),
        content: const Text('この予定を削除してもよろしいですか？'),
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
  }
}
