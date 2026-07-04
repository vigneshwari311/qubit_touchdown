import 'dart:convert';

import 'package:http/http.dart' as http;

class GameApi {
  static const String _baseUrl = "http://localhost:5000";

  static Future<Map<String, dynamic>> generateCircuit({
    required String playerId,
    required List<String> gates,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generate_circuit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'player_id': playerId, 'gates': gates}),
    );
    if (response.statusCode != 200) {
      throw Exception('generate_circuit failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> generateBlochAnimation({
    required String playerId,
    required List<String> gates,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/bloch_sphere_animation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'player_id': playerId, 'gates': gates}),
    );
    if (response.statusCode != 200) {
      throw Exception('bloch_sphere_animation failed: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}
