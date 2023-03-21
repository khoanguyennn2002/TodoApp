import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Event {
  final String title;
  final String? content;
  final DateTime date;
  final String id;
  final String uid;
  Event(
      {required this.title,
      this.content,
      required this.date,
      required this.id,
      required this.uid});
  Map<String, dynamic> toMap() => {
        "title": title,
        "content": content,
        "date": date,
      };
  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Event(
        date: data['date'].toDate(),
        title: data['title'],
        content: data['content'],
        id: snapshot.id,
        uid: data['uid']);
  }
  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "content": content,
      "uid": uid
    };
  }
}
