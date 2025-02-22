import 'package:fancale/calender/model/calender_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemoArea extends StatelessWidget {
  const MemoArea({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Calender>();

    final List<QueryDocumentSnapshot>? selectedDayDocuments =
        model.selectedDayDocuments;

    if (selectedDayDocuments == null) {
      return const CircularProgressIndicator();
    }

    return Expanded(
        child: ListView.builder(
            itemCount: selectedDayDocuments.length,
            itemBuilder: (context, index) {
              final document = selectedDayDocuments[index];
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
            }));
  }
}
