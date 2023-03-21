import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/note_details.dart';
import 'package:flutter_application_1/widget/buttonAdd.dart';
import 'package:flutter_application_1/widget/todocard.dart';
import 'package:intl/intl.dart';
import 'package:hexcolor/hexcolor.dart';

class MyDay extends StatefulWidget {
  const MyDay({super.key});
  @override
  State<MyDay> createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
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
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Row(
                      children: const [
                        Text(
                          "Ngày của tôi",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('E dd-MM-yyyy', 'vi').format(dateTime),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ])),
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
  DateTime today = DateTime.now();
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();

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
                          FirebaseAuth.instance.currentUser!.uid &&
                      document["time"] ==
                          DateFormat('E dd-MM-yyyy', 'vi').format(today) &&
                      document["finish"] == false) {
                    return Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                              time: document["time"] ==
                                      DateFormat('E dd-MM-yyyy', 'vi')
                                          .format(today)
                                  ? "Hôm nay"
                                  : "",
                              title: document["title"],
                              subtitle: "Tác vụ",
                              icon: Icons.calendar_month,
                              check: document["finish"],
                              important: document["important"] == true
                                  ? Icons.star
                                  : Icons.star_outline,
                              note: document["note"] == ""
                                  ? const Text("")
                                  : const Icon(
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
