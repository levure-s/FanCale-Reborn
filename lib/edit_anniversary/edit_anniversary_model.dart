import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditAnniversaryModel extends ChangeNotifier {
  Future updateAnniversary(
      String id, DateTime? selectedDay, String? text, String yearText) async {
    if (selectedDay == null) {
      throw '日付を選択してください';
    }
    if (text == null || text == '') {
      throw 'なんの記念日か入力してください';
    }

    final year = (yearText.isNotEmpty == true) ? int.tryParse(yearText) : 9999;

    if (year == null || year < 0) {
      throw '無効な年が入力されました';
    }

    final updatedDate = DateTime(year, selectedDay.month, selectedDay.day);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('anniversaries')
        .doc(id) // IDで特定して更新
        .update({
      'date': Timestamp.fromDate(updatedDate),
      'title': text,
      'uid': uid,
    });
    notifyListeners();
  }
}
