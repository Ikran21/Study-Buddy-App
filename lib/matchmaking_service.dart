import 'dart:convert';
import 'package:http/http.dart' as http;

class Match {
  final String id;
  final String name;
  final String email;
  final String availability;
  final String studyPreferences;

  Match({
    required this.id,
    required this.name,
    required this.email,
    required this.availability,
    required this.studyPreferences,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      availability: json['availability'],
      studyPreferences: json['study_preferences'],
    );
  }
}


class MatchmakingService {
  static Future<List<Match>> fetchMatches(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.0.142:8000/matchmaking.php?user_id=$userId'),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final matches = data['matches'] as List;
        return matches.map((json) => Match.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load matches: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching matches: $e");
      throw Exception('Error fetching matches: $e');
    }
  }
}
