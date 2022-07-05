import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ChatPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          GestureDetector(
              onTap: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              child: Icon(Icons.logout)),
        ],
      ),
      backgroundColor: Color(0xff435a64),
      body: SizedBox(
        height: scrHeight,
        width: scrWidth,
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ChatPage();
                    },
                  ));
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: Container(
                    height: 70,
                    child: Row(
                      children: [
                        Text("Name"),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}