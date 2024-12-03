import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/session_model.dart';

class HeaderWidget extends StatefulWidget {
  final String userId;

  const HeaderWidget({Key? key, required this.userId}) : super(key: key);

  @override
  HeaderWidgetState createState() => HeaderWidgetState();
}

class HeaderWidgetState extends State<HeaderWidget> {
  late Future<List<SessionModel>> _sessions;

  @override
  void initState() {
    super.initState();
    _sessions = ApiService.getSessions(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SessionModel>>(
      future: _sessions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingHeader();
        }
        if (snapshot.hasError) {
          return _buildErrorHeader();
        }

        final sessions = snapshot.data ?? [];

        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00D4FF), Color(0xff090979), Color(0xFF1709FB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${widget.userId} 👋',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Upcoming Lectures:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              sessions.isNotEmpty
                  ? SizedBox(
                      height: 150, // ارتفاع ثابت للكروت
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sessions.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return Container(
                            width: 220, // عرض الكرت
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  session.sessionName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF1709FB),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Time: ${session.time}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No upcoming sessions.",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00D4FF), Color(0xff090979), Color(0xFF1709FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: const [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 10),
          Text(
            "Loading upcoming sessions...",
            style: TextStyle(
                fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00D4FF), Color(0xff090979), Color(0xFF1709FB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
          const SizedBox(height: 10),
          const Text(
            'Error loading sessions. Please try again later.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
