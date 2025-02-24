import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountModel extends ChangeNotifier {
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    startLoading();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('ユーザーが見つかりません');
      }

      // Firestoreのユーザーデータを削除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Firebase Authenticationのユーザーを削除
      await user.delete();

      // Firebase Authからサインアウト
      await FirebaseAuth.instance.signOut();
    } finally {
      endLoading();
    }
  }
}
