import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAnniversaryModel extends ChangeNotifier {
  Future addAnniversary(DateTime? selectedDay, String? text) async {
    if (selectedDay == null) {
      throw '日付を選択してください';
    }
    if (text == null || text == '') {
      throw 'なんの記念日か入力してください';
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('anniversaries').add({
      'date': Timestamp.fromDate(selectedDay), // 日付をTimestampとして保存
      'title': text,
      'uid': uid,
    });
    notifyListeners();
  }
}
