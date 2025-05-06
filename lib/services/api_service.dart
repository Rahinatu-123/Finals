import '../models/career.dart';
import '../models/story.dart';
import '../models/tech_word.dart';

/// Mock API Service that returns hardcoded data instead of making HTTP requests
class ApiService {

  /// Get mock careers with a simulated network delay
  Future<List<Career>> getCareers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Career(
        id: '1',
        title: 'Software Developer',
        description: 'Develops software applications and systems',
        imageUrl: 'https://picsum.photos/200',
        skills: ['Programming', 'Problem Solving'],
        tools: ['VS Code', 'Git'],
        simulationType: 'Code Editor',
        deviceFeature: 'None',
      ),
      Career(
        id: '2',
        title: 'Data Scientist',
        description: 'Analyzes and interprets complex data',
        imageUrl: 'https://picsum.photos/201',
        skills: ['Statistics', 'Machine Learning'],
        tools: ['Python', 'R'],
        simulationType: 'Jupyter Notebook',
        deviceFeature: 'None',
      ),
    ];
  }

  /// Get mock stories with a simulated network delay
  Future<List<Story>> getStories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Story(
        id: '1',
        userId: 'mock-user-1',
        name: 'John Doe',
        role: 'Software Engineer',
        content: 'Started my journey as a self-taught developer...',
        createdAt: DateTime.now(),
      ),
      Story(
        id: '2',
        userId: 'mock-user-2',
        name: 'Jane Smith',
        role: 'Data Scientist',
        content: 'Transitioned from biology to data science...',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  /// Get mock tech words with a simulated network delay
  Future<List<TechWord>> getTechWords() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TechWord(
        id: '1',
        userId: 'mock-user-1',
        term: 'API',
        definition: 'Application Programming Interface - a set of rules that allow programs to talk to each other.',
        createdAt: DateTime.now(),
        isApproved: true,
      ),
      TechWord(
        id: '2',
        userId: 'mock-user-2',
        term: 'CORS',
        definition: 'Cross-Origin Resource Sharing - a security feature that lets web apps make requests to other domains.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isApproved: true,
      ),
    ];
  }

  /// Get a mock career by id with a simulated network delay
  Future<Career?> getCareerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final careers = await getCareers();
    try {
      return careers.firstWhere((career) => career.id == id);
    } catch (_) {
      return null;
    }
  }

  // Get story by id
  Future<Story?> getStoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final stories = await getStories();
    try {
      return stories.firstWhere((story) => story.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get a mock tech word by id with a simulated network delay
  Future<TechWord?> getTechWordById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final words = await getTechWords();
    try {
      return words.firstWhere((word) => word.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Create a mock story with a simulated network delay
  Future<Story> createStory(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Story(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      name: data['name'],
      role: data['role'],
      content: data['content'],
      createdAt: DateTime.now(),
    );
  }

  /// Create a mock tech word with a simulated network delay
  Future<TechWord> createTechWord(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TechWord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      term: data['term'],
      definition: data['definition'],
      createdAt: DateTime.now(),
      isApproved: false,
    );
  }

  /// Submit a mock quiz with a simulated network delay
  Future<Map<String, dynamic>> submitQuiz(List<Map<String, dynamic>> answers) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'score': 85,
      'total': 100,
      'correct': answers.length - 2,
      'incorrect': 2,
      'feedback': 'Great job! Keep learning!',
    };
  }
}
