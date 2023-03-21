import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? uid;
  final String title;
  final String note;
  final DateTime time;
  final bool important;

  Todo({
    this.uid,
    required this.title,
    required this.note,
    required this.important,
    required this.time,
  });
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'title': title,
        'time': time,
        'note': note,
        'important': important
      };
  static Todo fromJson(Map<String, dynamic> json) => Todo(
      uid: json['uid'],
      title: json['title'],
      note: json['note'],
      time: json['time'],
      important: json['important']);
}

Future<Todo?> getTodo() async {
  final docTodo = FirebaseFirestore.instance.collection('Todo').doc();
  final snapshot = await docTodo.get();

  if (snapshot.exists) {
    return Todo.fromJson(snapshot.data()!);
  }
}
