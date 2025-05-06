import 'package:flutter/material.dart';
import '../../models/tech_word.dart';
// import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class TechWordsScreen extends StatefulWidget {
  const TechWordsScreen({super.key});

  @override
  State<TechWordsScreen> createState() => _TechWordsScreenState();
}

class _TechWordsScreenState extends State<TechWordsScreen> {
  // final ApiService _apiService = ApiService();
  final _termController = TextEditingController();
  final _definitionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<TechWord> _techWords = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadTechWords();
  }

  @override
  void dispose() {
    _termController.dispose();
    _definitionController.dispose();
    super.dispose();
  }

  Future<void> _loadTechWords() async {
    // Temporarily using mock data while API is unavailable
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _techWords = [
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
      _isLoading = false;
    });
  }

  void _showAddWordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Tech Word'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _termController,
                labelText: 'Term',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a term';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _definitionController,
                labelText: 'Definition',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a definition';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Add',
            isLoading: _isSubmitting,
            onPressed: _submitTechWord,
          ),
        ],
      ),
    );
  }

  Future<void> _submitTechWord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final word = TechWord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      term: _termController.text,
      definition: _definitionController.text,
      createdAt: DateTime.now(),
      isApproved: false,
    );

    setState(() {
      _techWords.add(word);
      _isSubmitting = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
    _termController.clear();
    _definitionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tech word added successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech Words'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _techWords.length,
              itemBuilder: (context, index) {
                final word = _techWords[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      word.term,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(word.definition),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
