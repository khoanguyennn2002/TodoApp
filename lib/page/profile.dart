import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth.dart';
import 'package:flutter_application_1/page/home_page.dart';
import 'package:flutter_application_1/page/update_profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profie = FirebaseAuth.instance.currentUser?.uid;
  DocumentSnapshot? userSnapshot;
  File? imageFile;
  bool showLocalFile = false;

  getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    bool showLocalFile = false;
    userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {});
  }

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
      var fileName = userSnapshot!['email'] + '.jpg';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();

      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profileImage': profileImageUrl});

      Fluttertoast.showToast(msg: 'Profile image uploaded');

      print(profileImageUrl);

      progressDialog.dismiss();
    } catch (e) {
      progressDialog.dismiss();

      print(e.toString());
    }
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
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SafeArea(
                  child: ListView(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(children: [
                        Stack(
                          children: [
                            CircleAvatar(
                                radius: 60,
                                backgroundImage: showLocalFile
                                    ? FileImage(imageFile!) as ImageProvider
                                    : NetworkImage(
                                        userSnapshot!['profileImage'])),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.yellow[400]),
                                    child: GestureDetector(
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.black,
                                        size: 25,
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
                                    )))
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
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            width: 150,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellow[400]),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateProfile(
                                                username:
                                                    userSnapshot!["username"],
                                                email: userSnapshot!["email"],
                                              )));
                                },
                                child: const Text(
                                  "Chỉnh sửa",
                                  style: TextStyle(fontSize: 20),
                                ))),
                      ]),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.settings_outlined),
                          title: const Text("Cài đặt chung"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                          onTap: () {},
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: const Text("Thông báo"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                          onTap: () {},
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.light_mode_outlined),
                          title: const Text("Danh sách thông minh"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                          onTap: () {},
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.help_outline_outlined),
                          title: const Text("Trợ giúp & phản hồi"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                          onTap: () {},
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.info_outline_rounded),
                          title: const Text("Giới thiệu"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                          onTap: () {},
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: ListTile(
                          title: const Center(
                            child: Text(
                              "Đăng xuất",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Container(
                                          child: const Text(
                                              "Bạn có chắc chắn muốn đăng xuất không?")),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () {
                                              FirebaseAuth.instance
                                                  .signOut()
                                                  .then((value) => Navigator
                                                      .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const Auth()),
                                                          (route) => false));
                                            },
                                            child: const Text("Ok"))
                                      ],
                                    ));
                          },
                        )),
                    ListTile(
                      title: const Center(
                        child: Text(
                          "Xóa tài khoản",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      onTap: () {},
                    )
                  ]),
                )));
  }
}
