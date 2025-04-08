import 'package:flutter/material.dart';

class StudyBuddiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study Buddies")),
      body: Center(
        child: Text(
          "This is the Study Buddies Screen",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
