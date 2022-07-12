import 'package:chatapp/data.dart';
import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 90,

          backgroundColor: Colors.grey[200],
          elevation: 0,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.grey[600],
                ),
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
                width: 45,
                height: 45,
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
          // centerTitle: true,
          title: Text(
            widget.name,
            style: TextStyle(color: Colors.grey[600]),
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
                          if ((data[index]["senderId"] == widget.uid ||
                                  data[index]["receiverId"] == widget.uid) &&
                              (data[index]["senderId"] == widget.rid ||
                                  data[index]["receiverId"] == widget.rid)) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment:
                                    (data[index]["senderId"] == widget.rid
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color:
                                        (data[index]["senderId"] == widget.rid
                                            ? Colors.grey[200]
                                            : Colors.pink[50]),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    data[index]["message"],
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8.0, left: 5, right: 5),
                      child: Row(
                        children: [
                          Container(
                            width: scrWidth / 1.25,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.only(left: 4, bottom: 4),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.face),
                                Flexible(
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: const InputDecoration(
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
                                color: Colors.green,
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
                                    icon: const Icon(Icons.send_sharp)),
                              ],
                            ),
                          ),
                        ],
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
