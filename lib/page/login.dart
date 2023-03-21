import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth.dart';

import 'package:flutter_application_1/page/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPass = new TextEditingController();
  bool _obscureText = true;

  Future login() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: txtEmail.text.trim(), password: txtPass.text.trim());

      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
          (route) => false);
    } catch (e) {
      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text('Sai tài khoản hoặc mật khẩu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future login2(String email) async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: txtPass.text.trim());

      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Auth()),
          (route) => false);
    } catch (e) {
      Navigator.of(context).pop();
      final snackBar = SnackBar(content: Text('Sai tài khoản hoặc mật khẩu'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPass.dispose();
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
              child: Text("Đăng nhập",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
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
                            hintText: "Tên đăng nhập hoặc Email",
                            prefixIcon: const Icon(Icons.person_outlined),
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
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ))),
                      ),
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
                  onPressed: () async {
                    if (txtEmail.text.contains((new RegExp(r'@')))) {
                      login();
                    } else {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection('users')
                          .where('username', isEqualTo: txtEmail.text)
                          .get();
                      if (snap.docs.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(child: CircularProgressIndicator());
                            });
                        Navigator.pop(context);
                        final snackBar = SnackBar(
                            content: Text('Sai tài khoản hoặc mật khẩu'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        login2(snap.docs[0]['email']);
                      }
                    }
                  },
                  child: const Text("Đăng nhập")),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hoặc",
                  style: TextStyle(fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: const Text(
                    " Đăng kí",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const Divider(
              height: 50,
              color: Colors.white,
            )
          ]),
        ),
      ]),
    )));
  }
}
