import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/all_note.dart';
import 'package:flutter_application_1/page/important.dart';
import 'package:flutter_application_1/page/my_day.dart';
import 'package:flutter_application_1/page/plan.dart';
import 'package:flutter_application_1/page/profile.dart';
import 'package:flutter_application_1/widget/listcard.dart';
import 'package:flutter_application_1/widget/listscreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtName = new TextEditingController();
  final _createCategory = FirebaseFirestore.instance.collection("list");
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("list").snapshots();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  DocumentSnapshot? userSnapshot;

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    txtName.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            children: [
              GestureDetector(
                child: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text("To Do"),
              )
            ],
          ),
          actions: [
            GestureDetector(
              child: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.wb_sunny_outlined),
                    title: const Text("Ngày của tôi"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyDay()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_outline),
                    title: const Text("Quan trọng"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ImportantPage()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_outlined),
                    title: const Text("Lập kế hoạch"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Plan()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_work_outlined),
                    title: const Text("Tác vụ"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllNote()));
                    },
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 50,
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> document =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              if (document["uid"] == uid) {
                                return Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    child: ListCard(
                                      name: document["name"],
                                      id: snapshot.data!.docs[index].id,
                                    ));
                              }
                              return Container();
                            });
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(5, 30, 5, 0),
                      child: ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text("Danh sách mới"),
                          trailing: IconButton(
                            icon: const Icon(Icons.pivot_table_chart_outlined),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("Nhóm mới"),
                                        content: TextFormField(
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Cancel",
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "Ok",
                                              ))
                                        ],
                                      ));
                            },
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Tên danh sách"),
                                      content: TextFormField(
                                        controller: txtName,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.white),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Cancel",
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              _createCategory.add({
                                                "name": txtName.text,
                                                "uid": uid
                                              });
                                              txtName.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Ok",
                                            ))
                                      ],
                                    ));
                          })),
                ],
              )),
        ));
  }
}
