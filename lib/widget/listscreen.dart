import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/page/note_details.dart';
import 'package:flutter_application_1/widget/buttonAdd.dart';
import 'package:flutter_application_1/widget/todocard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  ListScreen({super.key, required this.title});
  String title;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool? check = false;

  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: const Text(
                                                "Tùy chọn danh sách",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 10),
                                              child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text("Hoàn thành")))
                                        ],
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.cleaning_services_outlined),
                                        title: const Text("Sắp xếp",
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        trailing:
                                            const Icon(Icons.arrow_forward_ios),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                            Icons.track_changes_outlined),
                                        title: const Text("Thay đổi chủ đề",
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        trailing:
                                            const Icon(Icons.arrow_forward_ios),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.share_outlined),
                                        title: const Text("Chia sẻ",
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        leading:
                                            const Icon(Icons.print_outlined),
                                        title: const Text("In danh sách",
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        onTap: () {},
                                      )
                                    ]),
                              ));
                    },
                    icon: const Icon(Icons.menu_outlined))
              ],
            ),
          )),
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Row(
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [],
                        ),
                      ])),
                ],
              ))),
      floatingActionButton: const ButtonAdd(),
    );
  }
}
