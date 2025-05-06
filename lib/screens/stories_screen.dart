import 'package:flutter/material.dart';
import '../../models/story.dart';
// import '../../services/api_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  // final ApiService _apiService = ApiService();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Story> _stories = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadStories() async {
    // Temporarily using mock data while API is unavailable
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _stories = [
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
      _isLoading = false;
    });
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
                controller: _nameController,
                labelText: 'Name',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _roleController,
                labelText: 'Role',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a role';
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      role: _roleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _stories.add(story);
      _isSubmitting = false;
    });

    if (!mounted) return;
    Navigator.pop(context);
    _nameController.clear();
    _roleController.clear();
    _contentController.clear();

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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                story.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    story.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    story.role,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(story.content),
                        if (story.imageUrl != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              story.imageUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
