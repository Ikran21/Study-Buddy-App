import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestApiCallScreen extends StatefulWidget {
  @override
  _TestApiCallScreenState createState() => _TestApiCallScreenState();
}

class _TestApiCallScreenState extends State<TestApiCallScreen> {
  String _result = 'Loading...';

  @override
  void initState() {
    super.initState();
    testCall();
  }

  Future<void> testCall() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.0.142:8000/matchmaking.php?user_id=1'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _result = 'Success:\n${response.body}';
        });
      } else {
        setState(() {
          _result = 'Failed:\nStatus Code: ${response.statusCode}\nBody: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text(_result)),
      ),
    );
  }
}
