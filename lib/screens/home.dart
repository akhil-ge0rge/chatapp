import 'package:chatapp/main.dart';
import 'package:chatapp/screens/TabBar.dart';
import 'package:chatapp/screens/call.dart';
import 'package:chatapp/screens/chat.dart';
import 'package:chatapp/screens/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double scrWidth = MediaQuery.of(context).size.width;
    double scrHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xff131a22),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                elevation: 0,
                backgroundColor: Color(0xff1e2c35),
                title: Text(
                  'WhatsApp',
                  style: TextStyle(color: Color(0xff8896a1)),
                ),
                actions: [
                  GestureDetector(
                      onTap: () async {
                        await GoogleSignIn().signOut();
                        FirebaseAuth.instance.signOut();
                      },
                      child: Icon(Icons.logout, color: Color(0xff8896a1))),
                  SizedBox(
                    width: 10,
                  )
                ],
                pinned: true,
                floating: true,
                bottom: TabBar(
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Color(0xff00aa81),
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.only(left: 5, right: 5),
                  controller: tabController,
                  tabs: [
                    Container(
                      width: scrWidth * 0.03,
                      height: 30,
                      child: Center(
                        child: Icon(Icons.camera_alt),
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.20,
                      height: 30,
                      child: Center(
                        child: Text("CHATS"),
                      ),
                    ),
                    Container(
                      width: scrWidth * 0.20,
                      height: 30,
                      child: Center(
                          child: Text(
                        "STATUS",
                      )),
                    ),
                    Container(
                      width: scrWidth * 0.20,
                      height: 30,
                      child: Center(
                          child: Text(
                        "CALLS",
                      )),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(controller: tabController, children: [
            Center(
              child: Text("Camera"),
            ),
            ChatScreen(),
            StatusScreen(),
            CallScreen(),
          ]),
        ));
  }
}
