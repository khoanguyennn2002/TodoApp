import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/buttonAdd.dart';
import 'package:flutter_application_1/widget/todocard.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'note_details.dart';

class AllNote extends StatefulWidget {
  const AllNote({super.key});
  @override
  State<AllNote> createState() => _AllNoteState();
}

class _AllNoteState extends State<AllNote> {
  DateTime today = DateTime.now();
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
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Tất cả ghi chú",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      )),
                  const Expanded(child: ShowData())
                ],
              ))),
      floatingActionButton: const ButtonAdd(),
    );
  }
}

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> document =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if (document["uid"] ==
                      FirebaseAuth.instance.currentUser!.uid) {
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoteDetails(
                                            title: document["title"],
                                            time: document["time"],
                                            id: snapshot.data!.docs[index].id,
                                            note: document["note"],
                                          )));
                            },
                            child: ToDoCard(
                              title: document["title"] == ""
                                  ? "Test"
                                  : document["title"],
                              time: document["time"] ==
                                      DateFormat('E dd-MM-yyyy', 'vi')
                                          .format(today)
                                  ? "Hôm nay"
                                  : document["time"],
                              subtitle: "Tác vụ",
                              icon: Icons.calendar_month,
                              check: document["finish"],
                              important: document["important"] == true
                                  ? Icons.star
                                  : Icons.star_outline,
                              note: document["note"] == ""
                                  ? Text("")
                                  : Icon(
                                      Icons.sticky_note_2_outlined,
                                      size: 13,
                                    ),
                              id: snapshot.data!.docs[index].id,
                              onChange: (newCheck) {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("Todo")
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({"finish": !document["finish"]});
                                });
                              },
                              starChange: () {
                                setState(() {
                                  FirebaseFirestore.instance
                                      .collection("Todo")
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({
                                    "important": !document["important"]
                                  });
                                });
                              },
                              enable: document["finish"] == true ? false : true,
                            )));
                  }
                  return Container();
                });
          },
        ));
  }
}
