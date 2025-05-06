import 'package:flutter/material.dart';
import '../services/career_service.dart';
import '../models/career.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({Key? key}) : super(key: key);

  @override
  _CareerScreenState createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _educationController = TextEditingController();
  final _salaryRangeController = TextEditingController();
  final _jobOutlookController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CareerService _careerService = CareerService();
  late Future<List<Career>> _futureCareers;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCareers();
  }

  Future<void> _loadCareers() async {
    setState(() {
      _futureCareers = _careerService.fetchCareers();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    _educationController.dispose();
    _salaryRangeController.dispose();
    _jobOutlookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Profiles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Career Profile'),
                  content: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            controller: _titleController,
                            labelText: 'Title',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _descriptionController,
                            labelText: 'Description',
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _skillsController,
                            labelText: 'Skills (comma-separated)',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter required skills';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _educationController,
                            labelText: 'Education',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter education requirements';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _salaryRangeController,
                            labelText: 'Salary Range',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter salary range';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _jobOutlookController,
                            labelText: 'Job Outlook',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter job outlook';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
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
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Career>>(
        future: _futureCareers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final careers = snapshot.data ?? [];

          if (careers.isEmpty) {
            return const Center(
              child: Text('No career profiles found'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: careers.length,
            itemBuilder: (context, index) {
              return _buildCareerCard(careers[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildCareerCard(Career career) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              career.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Skills', career.skills),
            _buildInfoRow('Education', career.education),
            _buildInfoRow('Salary Range', career.salaryRange),
            _buildInfoRow('Job Outlook', career.jobOutlook),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final career = Career(
        id: 0, // This will be set by the server
        title: _titleController.text,
        description: _descriptionController.text,
        skills: _skillsController.text,
        education: _educationController.text,
        salaryRange: _salaryRangeController.text,
        jobOutlook: _jobOutlookController.text,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _careerService.addCareer(career);
      
      // Clear form fields
      _titleController.clear();
      _descriptionController.clear();
      _skillsController.clear();
      _educationController.clear();
      _salaryRangeController.clear();
      _jobOutlookController.clear();

      // Close dialog and refresh careers
      if (mounted) {
        Navigator.pop(context);
        _loadCareers();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Career profile added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
} 