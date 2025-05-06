import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/career_profile.dart';
import '../models/story.dart';
import '../models/tech_word.dart';

class ApiService {
  static const String baseUrl = 'http://20.251.152.247/career_in_technology/api';
  final http.Client _client = http.Client();

  // Auth endpoints
  Future<User> login(String email, String password) async {
    // Commented out API call for testing
    // final response = await _client.post(
    //   Uri.parse('$baseUrl/login'),
    //   body: {'email': email, 'password': password},
    // );
    
    // if (response.statusCode == 200) {
    //   return User.fromJson(json.decode(response.body)['data']);
    // } else {
    //   throw Exception(json.decode(response.body)['message']);
    // }

    // Return mock user data for testing
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return User(
      id: '1',
      firstName: 'Test',
      lastName: 'User',
      email: email,
      role: 'student',
      createdAt: DateTime.now(),
    );
  }

  Future<User> register(String firstName, String lastName, String email,
      String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  // Career endpoints
  Future<List<CareerProfile>> getCareers() async {
    final response = await _client.get(Uri.parse('$baseUrl/careers'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      List<CareerProfile> careers = [];
      for (var item in data) {
        careers.add(CareerProfile.fromJson(item));
      }
      return careers;
    } else {
      throw Exception('Failed to load careers');
    }
  }

  Future<CareerProfile> getCareer(String id) async {
    final response = await _client.get(Uri.parse('$baseUrl/careers/$id'));

    if (response.statusCode == 200) {
      return CareerProfile.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load career');
    }
  }

  // Story endpoints
  Future<List<Story>> getStories() async {
    final response = await _client.get(Uri.parse('$baseUrl/stories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  Future<Story> createStory(String name, String role, String content,
      {String? imageUrl, String? videoUrl}) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/stories'),
      body: {
        'name': name,
        'role': role,
        'content': content,
        if (imageUrl != null) 'image_url': imageUrl,
        if (videoUrl != null) 'video_url': videoUrl,
      },
    );

    if (response.statusCode == 201) {
      return Story.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create story');
    }
  }

  // Tech Word endpoints
  Future<List<TechWord>> getTechWords() async {
    final response = await _client.get(Uri.parse('$baseUrl/techwords'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => TechWord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tech words');
    }
  }

  Future<TechWord> createTechWord(String term, String definition) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/techwords'),
      body: {
        'term': term,
        'definition': definition,
      },
    );

    if (response.statusCode == 201) {
      return TechWord.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create tech word');
    }
  }

  // Quiz endpoints
  Future<Map<String, dynamic>> submitQuiz(List<Map<String, dynamic>> answers) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/quiz/submit'),
      body: json.encode({'answers': answers}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to submit quiz');
    }
  }
}
