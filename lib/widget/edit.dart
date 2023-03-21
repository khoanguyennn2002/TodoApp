import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/provider/events.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  const EditEvent({Key? key, required this.event}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.event.date;
    _titleController = TextEditingController(text: widget.event.title);
    _contentController = TextEditingController(text: widget.event.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            controller: _titleController,
            maxLines: 1,
            decoration: const InputDecoration(labelText: 'title'),
          ),
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'content'),
          ),
          ElevatedButton(
            onPressed: () {
              _editEvent();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editEvent() async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isEmpty) {
      final snackBar = SnackBar(content: Text('Tiêu đề không được bỏ trống'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
        "title": title,
        "content": content,
      });
      _titleController.clear();
      _contentController.clear();
      Navigator.pop(context);
    }
  }
}
