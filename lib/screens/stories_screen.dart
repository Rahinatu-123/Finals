import 'package:flutter/material.dart';
import '../services/stories_service.dart';
import '../models/story.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  // final ApiService _apiService = ApiService();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  final _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<Story>> _futureStories;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _futureStories = StoriesService().fetchStories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _showAddStoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share an Inspiring Story'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Title',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _authorController,
                labelText: 'Author Name',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _contentController,
                labelText: 'Story',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please share the story';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _categoryController,
                labelText: 'Category',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
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
            text: 'Share',
            isLoading: _isSubmitting,
            onPressed: _submitStory,
          ),
        ],
      ),
    );
  }

  Future<void> _submitStory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final story = Story(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      content: _contentController.text,
      author: _authorController.text,
      date: DateTime.now().toString().split(' ')[0], // Format: YYYY-MM-DD
      category: _categoryController.text,
    );

    setState(() {
      _futureStories = Future.value([story]);
      _isSubmitting = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
    _titleController.clear();
    _contentController.clear();
    _authorController.clear();
    _categoryController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Story shared successfully!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success Stories'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Story>>(
        future: _futureStories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No stories available.'));
          }

          final stories = snapshot.data!;
          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    child: Text(story.author[0].toUpperCase()),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(
                    story.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('By ${story.author} • ${story.date}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(story.category),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddStoryDialog,
        icon: const Icon(Icons.add),
        label: const Text('Share a Story'),
      ),
    );
  }
}
