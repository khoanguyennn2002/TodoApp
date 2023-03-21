import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth.dart';
import 'package:flutter_application_1/main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class ButtonAdd extends StatefulWidget {
  const ButtonAdd({super.key});

  @override
  State<ButtonAdd> createState() => _ButtonAddState();
}

class _ButtonAddState extends State<ButtonAdd> {
  DateTime temp = DateTime.now();
  DateTime today = DateTime.now();
  DateTime dateTime = DateTime.now();
  DateTime date = DateTime.now();
  DateTime dateTime2 = DateTime.now();
  DateTime tomorow = DateTime.now().add(const Duration(days: 1));
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtNote = new TextEditingController();
  bool important = false;
  final _auth = FirebaseAuth.instance.currentUser!.uid;
  final _createList = FirebaseFirestore.instance.collection("Todo");

  @override
  void dispose() {
    txtTitle.dispose();
    txtNote.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black38,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.check_box_outline_blank,
                        ),
                        title: TextFormField(
                          controller: txtTitle,
                          decoration:
                              const InputDecoration(hintText: "Thêm tác vụ"),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            child: IconButton(
                              icon: const Icon(
                                Icons.home_work_outlined,
                                size: 30,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => StatefulBuilder(
                                          builder: (BuildContext context,
                                                  StateSetter sheetState) =>
                                              Container(
                                                  child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          child: const Text(
                                                            "Nhắc nhở",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                    ],
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(Icons
                                                        .watch_later_outlined),
                                                    title:
                                                        const Text("Cuối ngày",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            )),
                                                    trailing: const Text(
                                                      "14:00, Th 3",
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.calendar_today),
                                                    title:
                                                        const Text("Ngày mai",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            )),
                                                    trailing: const Text(
                                                        "09:00, Th 4"),
                                                    onTap: () {},
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(Icons
                                                        .calendar_month_outlined),
                                                    title:
                                                        const Text("Tuần tới",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                            )),
                                                    trailing: const Text(
                                                        "09:00, Th 4"),
                                                    onTap: () {},
                                                  ),
                                                  ListTile(
                                                      leading: const Icon(Icons
                                                          .watch_later_outlined),
                                                      title: const Text(
                                                          "Chọn ngày & giờ",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          )),
                                                      trailing: Text(dateTime
                                                              .year
                                                              .toString() +
                                                          "-" +
                                                          dateTime.month
                                                              .toString() +
                                                          "-" +
                                                          dateTime.day
                                                              .toString()),
                                                      onTap: () {
                                                        showDatePicker(
                                                                locale:
                                                                    const Locale(
                                                                        'vi',
                                                                        'VI'),
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        2000),
                                                                lastDate:
                                                                    DateTime(
                                                                        2050))
                                                            .then((value) {
                                                          sheetState(() {
                                                            dateTime = value!;
                                                          });
                                                        });
                                                      })
                                                ],
                                              ))));
                                },
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  size: 30,
                                )),
                          ),
                          Container(
                              child: IconButton(
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              size: 30,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                      builder: (BuildContext context,
                                              StateSetter sheetState) =>
                                          Container(
                                              child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: const Text(
                                                        "Đến hạn",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                ],
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.watch_later_outlined),
                                                title: const Text("Hôm nay",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                                trailing: Text(
                                                  DateFormat('E', 'vi')
                                                      .format(date),
                                                ),
                                                onTap: () {
                                                  sheetState(() {
                                                    temp = today;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.calendar_today),
                                                title: const Text("Ngày mai",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                                trailing: Text(
                                                  DateFormat('E', 'vi')
                                                      .format(tomorow),
                                                ),
                                                onTap: () {
                                                  sheetState(() {
                                                    temp = tomorow;
                                                  });
                                                  Navigator.pop(context);
                                                  ;
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons
                                                    .calendar_month_outlined),
                                                title: const Text("Tuần tới",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                                trailing: const Text("Th 2"),
                                                onTap: () {},
                                              ),
                                              ListTile(
                                                  leading: const Icon(Icons
                                                      .watch_later_outlined),
                                                  title: const Text("Chọn ngày",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      )),
                                                  trailing: Text(dateTime2.year
                                                          .toString() +
                                                      "-" +
                                                      dateTime2.month
                                                          .toString() +
                                                      "-" +
                                                      dateTime2.day.toString()),
                                                  onTap: () {
                                                    showDatePicker(
                                                            locale:
                                                                const Locale(
                                                                    'vi', 'VI'),
                                                            context: context,
                                                            initialDate:
                                                                DateTime.now(),
                                                            firstDate:
                                                                DateTime(2000),
                                                            lastDate:
                                                                DateTime(2050))
                                                        .then((value) {
                                                      sheetState(() {
                                                        dateTime2 = value!;
                                                        temp = value;
                                                      });
                                                      Navigator.pop(context);
                                                    });
                                                  })
                                            ],
                                          ))));
                            },
                          )),
                          Container(
                              child: IconButton(
                            icon: const Icon(
                              Icons.note_outlined,
                              size: 30,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                          child: Container(
                                        margin: const EdgeInsets.all(5),
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: txtNote,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "Thêm ghi chú"),
                                                maxLines: 5,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        child: const Icon(
                                                          Icons
                                                              .file_copy_outlined,
                                                          size: 30,
                                                        ),
                                                        onTap: () {},
                                                      ),
                                                      GestureDetector(
                                                        child: const Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 30,
                                                        ),
                                                        onTap: () {},
                                                      ),
                                                      GestureDetector(
                                                        child: const Icon(
                                                          Icons.mic,
                                                          size: 30,
                                                        ),
                                                        onTap: () {},
                                                      ),
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 100),
                                                          child: ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Hoàn thành")))
                                                    ]),
                                              )
                                            ]),
                                      )));
                            },
                          )),
                          Container(
                              margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (txtTitle.text != "") {
                                      _createList.add({
                                        "title": txtTitle.text,
                                        "time": DateFormat('E dd-MM-yyyy', 'vi')
                                            .format(temp),
                                        "uid": _auth,
                                        "note": txtNote.text,
                                        "important": false,
                                        "finish": false
                                      });
                                    }
                                    txtTitle.clear();
                                    txtNote.clear();
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Hoàn thành"))),
                        ],
                      )
                    ],
                  )));
        });
  }
}
