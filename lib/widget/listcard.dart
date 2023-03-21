import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/listscreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListCard extends StatefulWidget {
  ListCard({super.key, required this.name, required this.id});
  String name;
  String id;

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.2,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Xóa tác vụ sẽ xóa hoàn toàn danh sách này"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("list")
                                      .doc(widget.id)
                                      .delete();
                                  Navigator.pop(context);
                                },
                                child: const Text("Ok"))
                          ],
                        ));
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
            )
          ]),
      child: ListTile(
        leading: const Icon(Icons.menu),
        title: Text(widget.name),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListScreen(title: widget.name)));
        },
      ),
    );
  }
}
