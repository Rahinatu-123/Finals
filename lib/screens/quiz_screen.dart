import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What interests you the most?',
      'options': [
        'Building and creating things',
        'Solving complex problems',
        'Design and visual arts',
        'Working with data and numbers',
      ],
    },
    {
      'question': 'How do you prefer to work?',
      'options': [
        'Independently',
        'In a team',
        'Both, depending on the task',
        'Leading a team',
      ],
    },
    {
      'question': 'What type of problems do you enjoy solving?',
      'options': [
        'Technical and logical problems',
        'Creative and design challenges',
        'Business and strategic issues',
        'People and communication challenges',
      ],
    },
    {
      'question': 'Which technology interests you the most?',
      'options': [
        'Artificial Intelligence and Machine Learning',
        'Web and Mobile Development',
        'Cybersecurity',
        'Cloud Computing',
      ],
    },
    {
      'question': 'What\'s your preferred work environment?',
      'options': [
        'Fast-paced startup',
        'Large tech company',
        'Freelance/Independent',
        'Research and Development',
      ],
    },
  ];

  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _answers = [];
  bool _isSubmitting = false;

  void _selectAnswer(String answer) {
    setState(() {
      _answers.add({
        'question': _questions[_currentQuestionIndex]['question'],
        'answer': answer,
      });

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        _submitQuiz();
      }
    });
  }

  Future<void> _submitQuiz() async {
    setState(() => _isSubmitting = true);

    try {
      final result = await _apiService.submitQuiz(_answers);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(result: result),
        ),
      );
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Quiz'),
      ),
      body: _isSubmitting
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing your responses...'),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / _questions.length,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      currentQuestion['question'],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView.separated(
                        itemCount: currentQuestion['options'].length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final option = currentQuestion['options'][index];
                          return CustomButton(
                            text: option,
                            isOutlined: true,
                            onPressed: () => _selectAnswer(option),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const QuizResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.celebration,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Results Are Ready!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Based on your responses, here are the tech careers that might interest you:',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: (result['careers'] as List).length,
                  itemBuilder: (context, index) {
                    final career = result['careers'][index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          career['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(career['description']),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to career details
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Explore More Careers',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/careers');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
