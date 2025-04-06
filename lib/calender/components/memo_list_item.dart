import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancale/calender/model/calender_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoListItem extends StatelessWidget {
  final DocumentSnapshot document;

  const MemoListItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final model = context.read<Calender>();
    final date = (document['date'] as Timestamp).toDate();

    return ListTile(
      trailing: IconButton(
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('calendar')
              .doc(document.id)
              .delete();
          model.fetchCalender();
        },
        icon: const Icon(Icons.delete),
      ),
      title: Text(document['memo']),
      subtitle: Text('${date.year}/${date.month}/${date.day}'),
    );
  }
}
