import 'package:flutter/material.dart';
import '../models/career.dart';
// import '../services/api_service.dart';

class CareersScreen extends StatefulWidget {
  const CareersScreen({super.key});

  @override
  State<CareersScreen> createState() => _CareersScreenState();
}

class _CareersScreenState extends State<CareersScreen> {
  // final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Career> _careers = [];
  List<Career> _filteredCareers = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadCareers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCareers() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    // Temporarily using mock data while API is unavailable
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay

    if (!mounted) return;
    setState(() {
      _careers = [
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
      _filteredCareers = _careers;
      _isLoading = false;
    });
  }

  void _filterCareers(String query) {
    setState(() {
      _filteredCareers =
          _careers.where((career) {
            return career.title.toLowerCase().contains(query.toLowerCase()) ||
                career.description.toLowerCase().contains(query.toLowerCase());
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tech Careers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCareers,
              decoration: InputDecoration(
                hintText: 'Search careers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterCareers('');
                          },
                        )
                        : null,
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error.isNotEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadCareers,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                    : _filteredCareers.isEmpty
                    ? const Center(child: Text('No careers found'))
                    : ListView.builder(
                      itemCount: _filteredCareers.length,
                      itemBuilder: (context, index) {
                        final career = _filteredCareers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                career.imageUrl.isEmpty
                                    ? 'https://via.placeholder.com/150'
                                    : career.imageUrl,
                              ),
                            ),
                            title: Text(career.title),
                            subtitle: Text(
                              career.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/career-details',
                                arguments: Career(
                                  id: career.id,
                                  title: career.title,
                                  description: career.description,
                                  imageUrl: career.imageUrl,
                                  skills: [],
                                  tools: [],
                                  simulationType: '',
                                  deviceFeature: '',
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
