import 'package:fancale/calender/components/add_anniversary_button.dart';
import 'package:fancale/calender/components/add_button.dart';
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

    if (model.selectedDay == null) {
      return SizedBox.shrink();
    }

    return Expanded(
      child: ListView.builder(
          itemCount: selectedDayDocuments.length + 1,
          itemBuilder: (context, index) {
            if (index == selectedDayDocuments.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 中央に配置
                  children: [
                    AddButton(),
                    AddAnniversaryButton(),
                  ],
                ),
              );
            }

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
          }),
    );
  }
}
