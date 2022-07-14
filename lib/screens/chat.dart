import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/ChatPage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return SizedBox(
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
                          return ChatPage(
                            name: snapshot.data!.docs[index]['username'],
                            rid: snapshot.data!.docs[index]['userid'],
                            uid: userId,
                            image: snapshot.data!.docs[index]['userimage'],
                          );
                        }));
                      },
                      child: Card(
                        color: Color(0xff131a22),
                        elevation: .5,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10),
                          height: 65,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['userimage'],
                                ),
                              ),
                              SizedBox(
                                width: scrWidth / 15,
                              ),
                              Text(snapshot.data!.docs[index]['username'],
                                  style: TextStyle(
                                    color: Color(0xffe5ecf2),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
