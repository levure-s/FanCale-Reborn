import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditCalenderMemoModel extends ChangeNotifier {
  Future<void> updateMemo(
    String id,
    DateTime? selectedDay,
    String text,
  ) async {
    if (selectedDay == null) {
      throw '日付を選択してください';
    }
    if (text.isEmpty) {
      throw '予定を入力してください';
    }

    await FirebaseFirestore.instance.collection('calendar').doc(id).update({
      'date': Timestamp.fromDate(selectedDay),
      'memo': text,
    });

    notifyListeners();
  }
}
