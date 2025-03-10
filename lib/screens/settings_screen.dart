import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        // ✅ FIX: Enables scrolling
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            SizedBox(height: 10),
            Text("Sarah Smith",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("CS Major - Junior"),
            Divider(),
            _buildSettingsOption("Saved Messages"),
            _buildSettingsOption("Profile Information"),
            _buildSettingsOption("Account Info"),
            _buildSettingsOption("Notifications"),
            _buildSettingsOption("Appearance"),
            _buildSettingsOption("Language"),
            _buildSettingsOption("Privacy & Security"),
            _buildSettingsOption("Storage"),
          ],
        ),
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

  Widget _buildSettingsOption(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}
