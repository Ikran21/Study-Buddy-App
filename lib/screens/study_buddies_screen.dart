import 'package:flutter/material.dart';
import 'matchmaking_screen.dart';

class StudyBuddiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study Buddies")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "This is the Study Buddies Screen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20), // Spacing between text and button
          ElevatedButton.icon(
            icon: Icon(Icons.people_alt),
            label: Text("Find Study Matches"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MatchmakingScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
