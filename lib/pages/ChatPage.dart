import 'dart:async';

import 'package:chatapp/data.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  String uid;
  String rid;
  String name;
  String image;
  ChatPage(
      {Key? key,
      required this.rid,
      required this.uid,
      required this.name,
      required this.image})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  bool keyBoardShowing = true;
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff08151a),
        appBar: AppBar(
          leadingWidth: 90,
          backgroundColor: Color(0xff1e2c35),
          elevation: 0,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(0xfff8f8f8),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.4),
                      spreadRadius: .2,
                      blurRadius: 8,
                      offset: Offset(0, 1), // Shadow position
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                ),
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(color: Color(0xfff8f8f8), fontSize: 15),
              ),
              Text(
                "online",
                style: TextStyle(color: Color(0xfff8f8f8), fontSize: 11),
              ),
            ],
          ),
        ),
        body: SizedBox(
          height: scrHeight,
          width: scrWidth,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chat")
                  .orderBy("sendTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                var data = snapshot.data!.docs;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          //Dtae Time Conversion

                          Timestamp time = data[index]['sendTime'];
                          DateTime date = time.toDate();

                          if ((data[index]["senderId"] == widget.uid ||
                                  data[index]["receiverId"] == widget.uid) &&
                              (data[index]["senderId"] == widget.rid ||
                                  data[index]["receiverId"] == widget.rid)) {
                            return Align(
                              alignment: (data[index]["senderId"] == widget.rid
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: scrWidth - 45, minWidth: 110),
                                child: Card(
                                  elevation: .7,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: (data[index]["senderId"] ==
                                            widget.rid
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )
                                        : BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                  ),
                                  color: (data[index]["senderId"] == widget.rid
                                      ? Color(0xff1e2c35)
                                      : Color(0xff015c4b)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 30,
                                          top: 5,
                                          bottom: 20,
                                        ),
                                        child: Text(
                                          data[index]["message"],
                                          style: TextStyle(
                                            color: Color(0xffdfe4eb),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 4,
                                        right: 10,
                                        child: Row(
                                          children: [
                                            Text(
                                              DateFormat('h:mm a')
                                                  .format(date)
                                                  .toLowerCase(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xff77828b),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 10,
                        left: 5,
                        right: 5,
                      ),
                      // padding:
                      //     const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
                      child: Row(
                        children: [
                          Container(
                            width: scrWidth / 1.25,
                            decoration: BoxDecoration(
                                color: Color(0xff202c34),
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.only(left: 4, bottom: 4),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.emoji_emotions_outlined,
                                  color: Color(0xff82949f),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    onTap: () {
                                      keyBoardShowing = false;
                                      setState(() {});
                                      Timer(
                                        Duration(milliseconds: 700),
                                        () {
                                          keyBoardShowing = true;
                                        },
                                      );
                                    },
                                    style: TextStyle(color: Colors.white),
                                    cursorColor: Color(0xff0aa37d),
                                    controller: messageController,
                                    decoration: const InputDecoration(
                                        hintText: "Message",
                                        hintStyle:
                                            TextStyle(color: Color(0xff82949f)),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: scrWidth / 50,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xff01a885),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: scrWidth / 300,
                                ),
                                IconButton(
                                    onPressed: () {
                                      if (messageController.text.isNotEmpty) {
                                        sendMessage();
                                        messageController.clear();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.send_sharp,
                                      color: Color(0xfffffffd),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                      offstage: keyBoardShowing,
                      child: SizedBox(
                        height: 255,
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  sendMessage() {
    FirebaseFirestore.instance
        .collection('chat')
        .doc(DateTime.now().toString())
        .set({
      "message": messageController.text,
      "receiverId": widget.rid,
      "senderId": widget.uid,
      "sendTime": DateTime.now()
    });
  }
}
