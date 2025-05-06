import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tech_word.dart';

class TechWordsService {
  final String apiUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api/tech_words.php';

  Future<List<TechWord>> fetchTechWords() async {
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((json) => TechWord.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected data format: not a list');
        }
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse tech words');
      }
    } else {
      throw Exception('Failed to load tech words: ${response.statusCode}');
    }
  }
} 