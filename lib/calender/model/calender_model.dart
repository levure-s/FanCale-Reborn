import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends ChangeNotifier {
  final Stream<QuerySnapshot> _snapshots =
      FirebaseFirestore.instance.collection('calendar').snapshots();

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  List<QueryDocumentSnapshot>? myDocuments;
  List<QueryDocumentSnapshot>? selectedDayDocuments;

  void fetchCalender() {
    _snapshots.listen((QuerySnapshot snapshot) {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      final List<QueryDocumentSnapshot> docs = snapshot.docs.where((doc) {
        final uid = doc['uid'];
        return currentUid == uid;
      }).toList();
      myDocuments = docs;

      _filterDocuments();
    });
  }

  void changeFormat(format) {
    if (calendarFormat != format) {
      calendarFormat = format;
      notifyListeners();
    }
  }

  void changedDay(selected, focused) {
    focusedDay = focused;
    selectedDay = selected;

    _filterDocuments();
  }

  void changePage(focused) {
    if (focusedDay != focused) {
      focusedDay = focused;
      notifyListeners();
    }
  }

  void _filterDocuments() {
    if (myDocuments == null) {
      return notifyListeners();
    }
    final List<QueryDocumentSnapshot> filtered = myDocuments!.where((doc) {
      final date = (doc['date'] as Timestamp).toDate();
      return isSameDay(selectedDay, date);
    }).toList();

    selectedDayDocuments = filtered;
    notifyListeners();
  }

  List<QueryDocumentSnapshot> getEventsForDay(DateTime day) {
    if (myDocuments == null) return [];

    return myDocuments!.where((doc) {
      final date = (doc['date'] as Timestamp).toDate();
      return isSameDay(date, day);
    }).toList();
  }
}
