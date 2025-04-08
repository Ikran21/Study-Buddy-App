import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SEARCH FOR STUDY GROUPS"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildGroupCard("Computer Science", "Sessions Wed & Thurs 3-5 PM"),
          _buildGroupCard("Math 2500", "Sessions Friday 5-7 PM"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: Text("Create new Group"),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Study Buddies"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Search Groups"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }

  Widget _buildGroupCard(String title, String details) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(Icons.school),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("Join Group"),
        ),
      ),
    );
  }
}
