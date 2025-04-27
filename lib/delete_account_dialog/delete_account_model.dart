import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

      // カレンダーのメモを削除
      final calendarSnapshot = await FirebaseFirestore.instance
          .collection('calendar')
          .where('uid', isEqualTo: user.uid)
          .get();

      for (var doc in calendarSnapshot.docs) {
        await doc.reference.delete();
      }

      // グラフィックスのデータと画像を削除
      final graphicsSnapshot = await FirebaseFirestore.instance
          .collection('graphics')
          .where('uid', isEqualTo: user.uid)
          .get();

      for (var doc in graphicsSnapshot.docs) {
        // Firestoreのドキュメントを削除
        await doc.reference.delete();

        // Storage内の対応する画像を削除
        try {
          await FirebaseStorage.instance.ref('graphics/${doc.id}').delete();
        } catch (e) {
          // 画像が既に削除されている場合などのエラーは無視
          print('画像の削除でエラーが発生: $e');
        }
      }

      // ユーザーデータを削除
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // Firebase Authenticationのユーザーを削除
      await user.delete();

      // Firebase Authからサインアウト
      await FirebaseAuth.instance.signOut();

      notifyListeners();
    } finally {
      endLoading();
    }
  }
}
