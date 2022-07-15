import 'package:badges/badges.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/pages/statusPage.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return StatusPage();
              },
            ));
          },
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Badge(
                  position: BadgePosition(bottom: 1, start: 30),
                  badgeColor: Color(0xff168670),
                  badgeContent: Icon(
                    Icons.add,
                    size: 10,
                    color: Colors.white,
                  ),
                  toAnimate: false,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(userData.photoURL),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Status",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Tap to add status",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            "Recent Update",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
