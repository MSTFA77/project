import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/session_model.dart';

class CoursesScreen extends StatefulWidget {
  final String userId;

  const CoursesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late Future<List<SessionModel>> _courses;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _courses = ApiService.getSessions(widget.userId);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00D4FF),
              Color(0xff090979),
              Color(0xFF1709FB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _filter = value),
                  decoration: const InputDecoration(
                    labelText: 'Search Courses',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF1709FB)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
            ), // Courses List
            Expanded(
              child: FutureBuilder<List<SessionModel>>(
                future: _courses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading courses.',
                        style: TextStyle(fontSize: 16, color: Colors.redAccent),
                      ),
                    );
                  }
                  final courses = snapshot.data!
                      .where((course) => course.sessionName
                          .toLowerCase()
                          .contains(_filter.toLowerCase()))
                      .toList();

                  if (courses.isEmpty) {
                    return const Center(
                      child: Text(
                        "No courses found.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: courses.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue[50],
                                child:
                                    const Icon(Icons.book, color: Colors.blue),
                              ),
                              title: Text(
                                course.sessionName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1709FB),
                                ),
                              ),
                              subtitle: Text(
                                course.time,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: Color(0xFF1709FB)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(course.sessionName),
                                    content: Text(
                                        "Details about ${course.sessionName}..."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
