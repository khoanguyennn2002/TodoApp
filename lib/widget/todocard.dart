import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoCard extends StatelessWidget {
  ToDoCard(
      {super.key,
      required this.title,
      required this.check,
      this.icon,
      required this.starChange,
      required this.onChange,
      required this.subtitle,
      required this.important,
      this.icon1,
      this.note,
      required this.enable,
      required this.id,
      required this.time});
  final String title;
  String id;
  final IconData important;
  final String subtitle;
  IconData? icon;
  void Function(bool?) onChange;
  VoidCallback? starChange;
  dynamic note;
  IconData? icon1;
  final String time;
  final bool check;
  bool enable = true;

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
                                        .collection("Todo")
                                        .doc(id)
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
            enabled: enable,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Transform.scale(
                scale: 1.2,
                child: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    activeColor: Colors.grey,
                    value: check,
                    onChanged: onChange)),
            tileColor: Colors.black12,
            title: Text(
              title,
              style: const TextStyle(fontSize: 15),
            ),
            subtitle: Row(
              children: [
                Text(subtitle, style: const TextStyle(fontSize: 13)),
                note,
                Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 13,
                        ),
                        Text(time, style: const TextStyle(fontSize: 13)),
                      ],
                    )),
                Icon(
                  icon1,
                  size: 13,
                ),
              ],
            ),
            dense: true,
            trailing: IconButton(
                icon: Icon(
                  important,
                  size: 25,
                ),
                onPressed: starChange)));
  }
}
