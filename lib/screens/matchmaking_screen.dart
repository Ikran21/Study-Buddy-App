import 'package:flutter/material.dart';
import '../matchmaking_service.dart';

class MatchmakingScreen extends StatefulWidget {
  @override
  _MatchmakingScreenState createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> {
  late Future<List<Match>> _matches;

  @override
  void initState() {
    super.initState();
    _matches = MatchmakingService.fetchMatches(1); // user_id = 1 for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match Suggestions')),
      body: FutureBuilder<List<Match>>(
        future: _matches,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading matches'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No matches found.'));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(match.name),
                  subtitle: Text(
                    'Availability: ${match.availability}\nPreferences: ${match.studyPreferences}',
                  ),
                  trailing: Icon(Icons.message),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
