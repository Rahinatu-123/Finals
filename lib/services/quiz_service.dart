import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz.dart';

class QuizService {
  final String baseUrl = 'http://20.251.152.247/career_in_technology/ctech-web/api/quiz_questions.php';

  Future<List<Quiz>> fetchQuestions() async {
    final response = await http.get(Uri.parse(baseUrl));
    
    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.map((json) => Quiz.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected data format: not a list');
        }
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse quiz questions');
      }
    } else {
      throw Exception('Failed to load quiz questions: ${response.statusCode}');
    }
  }

  Future<QuizResult> submitQuiz(List<QuizAnswer> answers) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submit_quiz.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(answers.map((answer) => answer.toJson()).toList()),
    );

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        return QuizResult.fromJson(decoded);
      } catch (e) {
        print('JSON parsing error: $e');
        throw Exception('Failed to parse quiz results');
      }
    } else {
      throw Exception('Failed to submit quiz: ${response.statusCode}');
    }
  }
} 