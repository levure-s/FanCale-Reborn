import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileModel extends ChangeNotifier {
  EditProfileModel(this.currentName) {
    nameController.text = currentName;
  }
  final nameController = TextEditingController();
  final String currentName;

  String? name;
  bool isLoading = false;
  Color color = Colors.blue;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setColor(Color color) {
    this.color = color;
    notifyListeners();
  }

  bool isUpdated() {
    return name != null;
  }

  Future update() async {
    name = nameController.text;
    int colorInt = color.value;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'name': name, 'color': colorInt});
  }
}
