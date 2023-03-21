import 'dart:io';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ndialog/ndialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProfile extends StatefulWidget {
  String email;
  String username;
  UpdateProfile({super.key, required this.username, required this.email});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? profie = FirebaseAuth.instance.currentUser?.uid;
  DocumentSnapshot? userSnapshot;

  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPass = new TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;

  getUserDetails() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: userSnapshot == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SafeArea(
                        child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                          userSnapshot!['profileImage'])),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                userSnapshot!['username'],
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Text(userSnapshot!['email']),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Text("Tên đăng nhập:"),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(widget.username),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  txtUsername.text =
                                                      widget.username;

                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          "Đổi username:"),
                                                      content: TextFormField(
                                                        controller: txtUsername,
                                                        decoration:
                                                            const InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {},
                                                            child: const Text(
                                                                "Cancel")),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                widget.username =
                                                                    txtUsername
                                                                        .text;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Ok"))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Text("Email:"),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(widget.email),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  txtEmail.text = widget.email;

                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text("Đổi email:"),
                                                      content: TextFormField(
                                                        controller: txtEmail,
                                                        decoration:
                                                            const InputDecoration(
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {},
                                                            child:
                                                                Text("Cancel")),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                widget.email =
                                                                    txtEmail
                                                                        .text;
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("Ok"))
                                                      ],
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 8),
                                          child: Text("Xác nhận:"),
                                        ),
                                        TextFormField(
                                          controller: txtPass,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            hintText: "Xác nhận mật khẩu",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            margin: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            child: ElevatedButton(
                                              child: const Text("Save"),
                                              onPressed: () async {
                                                if (txtPass.text.isEmpty) {
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          'Vui lòng nhập xác nhận mật khẩu để đổi email/user'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                } else {
                                                  var user = FirebaseAuth
                                                      .instance.currentUser!;
                                                  var auth = await user
                                                      .reauthenticateWithCredential(
                                                          EmailAuthProvider
                                                              .credential(
                                                                  email: user
                                                                      .email!,
                                                                  password:
                                                                      txtPass
                                                                          .text));
                                                  auth.user!.updateEmail(
                                                      widget.email);
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(uid)
                                                      .update({
                                                    "username": widget.username,
                                                    "email": widget.email
                                                  });
                                                  ProgressDialog
                                                      progressDialog =
                                                      ProgressDialog(
                                                    context,
                                                    title: const Text(
                                                        'Uploading !!!'),
                                                    message: const Text(
                                                        'Please wait'),
                                                  );
                                                  progressDialog.show();
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const HomePage()),
                                                      ModalRoute.withName('/'));
                                                }
                                              },
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.yellow[600]),
                                                  foregroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                            ))
                                      ]))
                            ]))))));
  }
}
