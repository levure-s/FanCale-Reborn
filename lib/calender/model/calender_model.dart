import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends ChangeNotifier {
  final Stream<QuerySnapshot> _snapshots =
      FirebaseFirestore.instance.collection('calendar').snapshots();
  final Stream<QuerySnapshot> _anniversarySnapshots =
      FirebaseFirestore.instance.collection('anniversaries').snapshots();

  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  List<QueryDocumentSnapshot>? myDocuments;
  List<QueryDocumentSnapshot>? anniversaryDocuments;
  List<QueryDocumentSnapshot>? selectedDayDocuments;

  void fetchCalender() {
    _anniversarySnapshots.listen((QuerySnapshot snapshot) {
      final currentUid = FirebaseAuth.instance.currentUser?.uid; // ユーザーIDを取得
      final List<QueryDocumentSnapshot> docs = snapshot.docs.where((doc) {
        final uid = doc['uid'];
        return currentUid == uid; // UIDで絞り込む
      }).toList();
      anniversaryDocuments = docs;

      _filterAnniversaries();
    });

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

    _filterAnniversaries();
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

    selectedDayDocuments?.addAll(filtered);
    notifyListeners();
  }

  void _filterAnniversaries() {
    if (anniversaryDocuments == null) {
      return notifyListeners();
    }

    final List<QueryDocumentSnapshot> filtered =
        anniversaryDocuments!.where((doc) {
      final date = (doc['date'] as Timestamp).toDate();
      final selectedDayMonth = selectedDay?.month;
      final selectedDayDay = selectedDay?.day;

      // 年を無視して月日だけを比較
      return selectedDayMonth == date.month && selectedDayDay == date.day;
    }).toList();

    selectedDayDocuments = filtered;
    notifyListeners();
  }

  List<QueryDocumentSnapshot> getEventsForDay(DateTime day) {
    List<QueryDocumentSnapshot> events = [];
    if (myDocuments != null) {
      events = myDocuments!.where((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        return isSameDay(date, day);
      }).toList();
    }

    if (anniversaryDocuments != null) {
      final List<QueryDocumentSnapshot> filtered =
          anniversaryDocuments!.where((doc) {
        final date = (doc['date'] as Timestamp).toDate();
        final selectedDayMonth = day.month;
        final selectedDayDay = day.day;

        // 年を無視して月日だけを比較
        return selectedDayMonth == date.month && selectedDayDay == date.day;
      }).toList();
      events.addAll(filtered);
    }

    return events;
  }
}
