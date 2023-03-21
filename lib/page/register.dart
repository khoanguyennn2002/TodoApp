import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/page/login.dart';
import 'package:flutter_application_1/provider/user.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  bool _obscureText1 = true;
  TextEditingController txtUsername = new TextEditingController();
  TextEditingController txtPass = new TextEditingController();
  TextEditingController txtPass1 = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  List<UserModel> allUser = [];
  bool checkUser = false;
  Future _singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  user() async {
    var records = await FirebaseFirestore.instance.collection('users').get();
    getAllUser(records);
  }

  getAllUser(QuerySnapshot<Map<String, dynamic>> map) {
    var list = map.docs
        .map((e) => UserModel(
            username: e["username"],
            email: e["email"],
            profileImage: e["profileImage"]))
        .toList();
    allUser = list;
  }

  Future register1() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    if (txtPass1.text == txtPass.text) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
                email: txtEmail.text, password: txtPass.text);

        if (userCredential.user != null) {
          FirebaseFirestore firestore = FirebaseFirestore.instance;

          String uid = userCredential.user!.uid;

          firestore.collection('users').doc(uid).set({
            'username': txtUsername.text,
            'email': txtEmail.text,
            'profileImage':
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRkiIFjCOZ-mMeqxd2ryrneiHedE8G9S0AboA&usqp=CAU'
          });

          Navigator.of(context).pop();
          final snackBar = SnackBar(content: Text('Đăng kí thành công'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          txtUsername.clear();
          txtEmail.clear();
          txtPass.clear();
          txtPass1.clear();
        } else {
          Navigator.of(context).pop();
          final snackBar = SnackBar(content: Text('Đăng kí thất bại'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          txtUsername.clear();
          txtEmail.clear();
          txtPass.clear();
          txtPass1.clear();
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'email-already-in-use') {
          final snackBar = SnackBar(content: Text('Email đã sử dụng'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (e.code == 'weak-password') {
          final snackBar = SnackBar(content: Text('tài khoản yếu'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        Navigator.of(context).pop();
        final snackBar = SnackBar(content: Text('Lỗi mạng'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text('Mật khẩu không trùng'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    user();
    super.initState();
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPass.dispose();
    txtPass1.dispose();
    txtUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Image.asset(
              "assets/todo.png",
              width: 100,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
              child: Text("Đăng kí",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                  )),
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: TextField(
                          controller: txtUsername,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Tên đăng nhập",
                              prefixIcon:
                                  const Icon(Icons.person_outline_outlined),
                              hintStyle: const TextStyle()),
                          onChanged: (newValue) {
                            setState(() {
                              checkUser = false;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: TextField(
                          controller: txtEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintStyle: const TextStyle(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: TextField(
                          controller: txtPass,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Mật khẩu",
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintStyle: const TextStyle(),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                        child: TextField(
                          controller: txtPass1,
                          obscureText: _obscureText1,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Xác nhận mật khẩu",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText1 = !_obscureText1;
                                  });
                                },
                                child: Icon(_obscureText1
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              )),
                        ),
                      )
                    ])),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              width: MediaQuery.of(context).size.width / 1.2,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black12)),
                  onPressed: () {
                    for (var list in allUser) {
                      if (list.username.toString() == txtUsername.text) {
                        checkUser = true;
                        break;
                      }
                    }
                    if (txtUsername.text.isEmpty) {
                      const snackBar = SnackBar(
                          content: Text('vui lòng điền đầy đủ thông tin'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (txtEmail.text.isEmpty) {
                      const snackBar = SnackBar(
                          content: Text('Vui lòng điền đầy đủ thông tin'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (txtPass.text.length < 8) {
                      const snackBar = SnackBar(
                          content: Text('Mật khẩu phải có ít nhất 8 kí tự'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (checkUser) {
                      const snackBar =
                          SnackBar(content: Text('Tài khoản đã tồn tại'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      register1();
                    }
                  },
                  child: const Text("Đăng kí")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bạn đã có tài khoản?",
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    _singOut().then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false));
                  },
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ]),
        ),
      ]),
    )));
  }
}
