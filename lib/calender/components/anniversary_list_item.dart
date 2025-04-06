import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancale/calender/model/calender_model.dart';
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
            await FirebaseFirestore.instance
                .collection('anniversaries')
                .doc(document.id)
                .delete();
            model.fetchCalender();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'delete',
            child: Text('削除'),
          ),
        ],
      ),
    );
  }
}
