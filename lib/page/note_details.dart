import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

class NoteDetails extends StatefulWidget {
  String title;
  String time;
  String id;
  String note;
  NoteDetails(
      {super.key,
      required this.title,
      required this.time,
      required this.id,
      required this.note});

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  bool? checked = false;
  bool ischecked = false;
  File? imageFile;
  bool showLocalFile = false;
  DateTime temp = DateTime.now();
  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtNote = new TextEditingController();
  DateTime dateTime2 = DateTime.now();

  _pickImageFrom(ImageSource imageSource) async {
    XFile? xFile = await ImagePicker().pickImage(source: imageSource);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Vui lòng đợi'),
    );
    progressDialog.show();
    try {
      var fileName = '${widget.title}.jpg';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('note_image')
          .child(fileName)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
        "note": profileImageUrl,
      });

      Fluttertoast.showToast(msg: 'Note image uploaded');

      print(profileImageUrl);

      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();

      print(e.toString());
    }
  }

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
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Todo")
                            .doc(widget.id)
                            .update({
                          "title": widget.title,
                          "note": widget.note,
                          "time": widget.time,
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Hoàn thành",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            )),
        extendBodyBehindAppBar: true,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(children: [
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          txtTitle.text = widget.title;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Change Title"),
                                    content: TextField(
                                      controller: txtTitle,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              widget.title = txtTitle.text;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.edit_outlined))
                  ],
                )),
            Container(
                padding: const EdgeInsets.all(8),
                child: const TextField(
                  decoration: InputDecoration(
                      hintText: "Thêm bước", prefixIcon: Icon(Icons.add)),
                )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.list_outlined),
                title: const Text(
                  "Thêm danh sách",
                  style: TextStyle(fontSize: 15),
                ),
                trailing: const Icon(
                  Icons.close_outlined,
                  size: 17,
                ),
                onTap: () {},
              ),
            ),
            const Divider(
              height: 10,
              indent: 8,
              endIndent: 8,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text(
                  "Nhắc tôi lúc 12:00",
                  style: TextStyle(fontSize: 15),
                ),
                subtitle: const Text(
                  "Hôm nay",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.close_outlined,
                  size: 15,
                ),
                onTap: () {},
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text(
                    "Sửa ngày đến hạn",
                    style: TextStyle(fontSize: 15),
                  ),
                  trailing: Text(
                    widget.time,
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    showDatePicker(
                            locale: const Locale('vi', 'VI'),
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050))
                        .then((value) {
                      setState(() {
                        widget.time =
                            DateFormat('E dd-MM-yyyy', 'vi').format(value!);
                        temp = value;
                      });
                    });
                  },
                )),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.loop_outlined),
                title: const Text(
                  "Lặp lại",
                  style: TextStyle(fontSize: 15),
                ),
                trailing: const Icon(
                  Icons.close_outlined,
                  size: 15,
                ),
                onTap: () {},
              ),
            ),
            const Divider(
              height: 10,
              indent: 8,
              endIndent: 8,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.file_copy_outlined),
                title: const Text(
                  "Thêm tệp",
                  style: TextStyle(fontSize: 15),
                ),
                trailing: const Icon(
                  Icons.close_outlined,
                  size: 15,
                ),
                onTap: () {},
              ),
            ),
            const Divider(
              height: 10,
              indent: 8,
              endIndent: 8,
              color: Colors.white,
            ),
            ListTile(
              title: Text(
                widget.note == "" ? "Ghi chú" : widget.note,
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                txtNote.text = widget.note;
                showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                            child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          margin: const EdgeInsets.all(5),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            TextField(
                              controller: txtNote,
                              decoration: const InputDecoration(
                                  hintText: "Thêm ghi chú"),
                              maxLines: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.file_copy_outlined,
                                        size: 30,
                                      ),
                                      onTap: () {},
                                    ),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 30,
                                      ),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.image),
                                                      title: const Text(
                                                          'Thư viện'),
                                                      onTap: () {
                                                        _pickImageFrom(
                                                            ImageSource
                                                                .gallery);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.camera_alt),
                                                      title: const Text(
                                                          'Chụp ảnh'),
                                                      onTap: () {
                                                        _pickImageFrom(
                                                            ImageSource.camera);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
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
                                            const EdgeInsets.only(left: 100),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                widget.note = txtNote.text;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Hoàn thành")))
                                  ]),
                            ),
                          ]),
                        )));
              },
            ),
          ]),
        ));
  }
}
