import 'package:chatapp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:story_view/story_view.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<StoryItem> stories = [];
  var statusList;
  getList() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .snapshots()
        .listen((event) {
      statusList = event.get('status');
      if (mounted) {
        for (int i = 0; i < statusList.length; i++) {
          setState(() {
            if (statusList[i]['type'] == 'image') {
              stories.add(StoryItem.pageImage(
                  url: statusList[i]['url'], controller: storyController));
            } else if (statusList[i]['type'] == 'video') {
              stories.add(StoryItem.pageVideo(statusList[i]['url'],
                  controller: storyController));
            } else if (statusList[i]['type'] == 'text') {
              stories.add(StoryItem.text(
                  title: statusList[i]['text'], backgroundColor: Colors.pink));
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
          storyItems: [for (int i = 0; i < stories.length; i++) stories[i]],
          controller: storyController),
    );
  }
}
