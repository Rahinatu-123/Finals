import 'package:flutter/material.dart';
import '../../models/tech_word.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class TechWordsScreen extends StatefulWidget {
  const TechWordsScreen({super.key});

  @override
  State<TechWordsScreen> createState() => _TechWordsScreenState();
}

class _TechWordsScreenState extends State<TechWordsScreen> {
  final ApiService _apiService = ApiService();
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
    try {
      final words = await _apiService.getTechWords();
      setState(() {
        _techWords = words;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // TODO: Handle error
    }
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

    try {
      final word = await _apiService.createTechWord(
        _termController.text,
        _definitionController.text,
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
