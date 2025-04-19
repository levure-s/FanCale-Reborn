import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:fancale/edit_anniversary/edit_anniversary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnniversaryListItem extends StatelessWidget {
  final DocumentSnapshot document;
  final DateTime selectedDay;

  const AnniversaryListItem({
    super.key,
    required this.document,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<Calender>();
    final date = (document['date'] as Timestamp).toDate();
    int years = selectedDay.year - date.year;
    if (selectedDay.month < date.month ||
        (selectedDay.month == date.month && selectedDay.day < date.day)) {
      years--;
    }

    return Dismissible(
        key: Key(document.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete,
                    color: Theme.of(context).colorScheme.onPrimary)),
          ),
        ),
        confirmDismiss: (direction) async {
          return await _showDeleteDialog(context);
        },
        onDismissed: (direction) async {
          await model.deleteAnniversary(document.id);
        },
        child: ListTile(
          title: Text(
            '🎂 ${document["title"]}',
            style: TextStyle(fontSize: 18),
          ),
          subtitle: years > 0 ? _buildAnniversaryBadge(years, context) : null,
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await _showDeleteDialog(context);

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
        ));
  }

  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
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
  }

  Widget _buildAnniversaryBadge(int years, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // 余白
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 250, 197, 74),
              borderRadius: BorderRadius.circular(20), // 丸くする
            ),
            child: Text(
              '$years周年',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
