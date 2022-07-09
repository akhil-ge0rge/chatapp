import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user")
                .where("userid", isNotEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Text("No Chats ");
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatPage();
                          }));
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 70,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(snapshot
                                        .data!.docs[index]['userimage']),
                                  ),
                                ),
                                SizedBox(
                                  width: scrWidth / 15,
                                ),
                                Text(snapshot.data!.docs[index]['username']),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
