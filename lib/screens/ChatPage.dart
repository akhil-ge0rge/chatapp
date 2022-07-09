import 'package:chatapp/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: scrHeight,
        width: scrWidth,
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("chat").snapshots(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages[index]["messageType"] == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[index]["messageType"] == "receiver"
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              messages[index]["messageContent"],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        width: 310,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20)
                        ),

                        margin: EdgeInsets.only(left: 4,bottom: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.face),
                            Flexible(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none
                                ),

                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(

                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 3
                            ),
                            IconButton(
                                onPressed: (){}, icon: Icon(Icons.send_sharp)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
