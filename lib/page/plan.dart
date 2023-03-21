import 'dart:collection';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/edit.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../provider/events.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  CalendarFormat? format;
  TextEditingController txtEvent = new TextEditingController();
  TextEditingController txtTitle = new TextEditingController();
  DateTime? _focusedDay;
  DateTime? _selectedDay;
  late Map<DateTime, List<Event>> _events;
  void _addEvent() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (txtTitle.text.isEmpty) {
      final snackBar = SnackBar(content: Text('Tiêu đề không được bỏ trống'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context);
    } else {
      await FirebaseFirestore.instance.collection('events').add({
        "title": txtTitle.text,
        "content": txtEvent.text,
        "date": Timestamp.fromDate(_selectedDay!),
        "uid": uid
      });

      txtTitle.clear();
      txtEvent.clear();
      Navigator.pop(context);
      _loadEvents();
    }
  }

  void _onDaySelected(selectedDay, focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    format = CalendarFormat.month;
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _loadEvents();
  }

  _loadEvents() async {
    _events = {};

    final snap = await FirebaseFirestore.instance
        .collection('events')
        .withConverter(
            fromFirestore: Event.fromFirestore,
            toFirestore: (event, options) => event.toFirestore())
        .get();

    for (var doc in snap.docs) {
      final event = doc.data();
      final day =
          DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (_events[day] == null) {
        _events[day] = [];
      }
      if (event.uid == FirebaseAuth.instance.currentUser!.uid) {
        _events[day]!.add(event);
      }
    }
    setState(() {});
  }

  List<Event> _getEventsForTheDay(day) {
    return _events[day] ?? [];
  }

  @override
  void dispose() {
    txtEvent.dispose();
    txtTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          )),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: ListView(children: [
        TableCalendar(
          calendarBuilders: CalendarBuilders(
            markerBuilder: (BuildContext context, date, events) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        width: 5,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      ),
                    );
                  });
            },
          ),
          locale: "vi_VI",
          headerStyle: const HeaderStyle(
            titleCentered: true,
          ),
          calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration:
                  BoxDecoration(color: Colors.red[400], shape: BoxShape.circle),
              todayDecoration: BoxDecoration(
                  color: Colors.red[200], shape: BoxShape.circle)),
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          availableGestures: AvailableGestures.all,
          firstDay: DateTime(2000),
          focusedDay: _focusedDay!,
          lastDay: DateTime(2050),
          onDaySelected: _onDaySelected,
          calendarFormat: format!,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          },
          eventLoader: _getEventsForTheDay,
        ),
        ..._getEventsForTheDay(_selectedDay!).map((event) => ListTile(
              leading: const Icon(
                Icons.done,
                color: Colors.teal,
              ),
              title: Text(event.title),
              subtitle: Text(event.date.year.toString() +
                  "-" +
                  event.date.month.toString() +
                  "-" +
                  event.date.day.toString()),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEvent(event: event)));
                _loadEvents();
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Xác nhận"),
                            content: const Text(
                                "Xóa tác vụ sẽ xóa hoàn toàn tác vụ này"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("events")
                                        .doc(event.id)
                                        .delete();
                                    Navigator.pop(context);
                                    _loadEvents();
                                  },
                                  child: const Text("Ok"))
                            ],
                          ));
                },
              ),
            ))
      ])),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => Container(
              child: AlertDialog(
            title: const Text("Thêm sự kiện"),
            content: Container(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextFormField(
                controller: txtTitle,
                decoration: const InputDecoration(
                    hintText: "Tiêu đề",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
              TextFormField(
                controller: txtEvent,
                decoration: const InputDecoration(
                    hintText: "Ghi chú",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold)),
              )
            ])),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    _addEvent();
                  },
                  child: const Text("Ok"))
            ],
          )),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add),
        label: const Text("Thêm sự kiện"),
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
