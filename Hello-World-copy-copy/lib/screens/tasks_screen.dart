import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TasksScreen extends StatefulWidget {
  final String userId;

  const TasksScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<String>> _tasks;
  final Map<String, bool> _completedTasks = {};
  final Map<String, String> _taskFiles = {};

  @override
  void initState() {
    super.initState();
    _tasks = ApiService.getTasks(widget.userId);
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
        child: FutureBuilder<List<String>>(
          future: _tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading tasks.'));
            }

            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          _completedTasks[task] == true
                              ? Icons.check_circle
                              : Icons.task_alt,
                          color: _completedTasks[task] == true
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF1709FB),
                        ),
                        title: Text(
                          task,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF313133),
                          ),
                        ),
                        trailing: Checkbox(
                          value: _completedTasks[task] ?? false,
                          onChanged: (value) {
                            setState(() {
                              _completedTasks[task] = value!;
                            });
                            if (value!) {
                              _showSnackBar('Task marked as completed!');
                            }
                          },
                          activeColor: const Color(0xFF1709FB),
                          checkColor: Colors.white,
                        ),
                      ),
                      if (_taskFiles[task] != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'File attached: ${_taskFiles[task]}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _taskFiles[task] = 'dummy_file.pdf';
                            });
                            _showSnackBar('File attached successfully!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff9a9adf),
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Attach File',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
