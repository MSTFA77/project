import 'dart:math';
import '../models/session_model.dart';

class ApiService {
  static final Random _random = Random();

  // قائمة الطلاب المُسجلة مسبقاً
  static final List<Map<String, String>> _students = [
    {"name": "Ali Mohamed", "password": "622039"},
    {"name": "Mostafa Mohamed", "password": "622066"},
    {"name": "a", "password": "a"},
    {"name": "Hassan Attia", "password": "H"},
    {"name": "Hesham", "password": "H"},
    {"name": "Kerolos", "password": "K"},
    {"name": "Kareem", "password": "K"},
    {"name": "Ff Ff", "password": "Ff Ff"},
    {"name": "Gg Gg", "password": "Gg Gg"},
    {"name": "Hh Hh", "password": "Hh Hh"},
  ];

  /// التحقق من بيانات تسجيل الدخول
  static bool validateLogin(String name, String password) {
    return _students.any((student) =>
        student["name"]?.toLowerCase() == name.toLowerCase() &&
        student["password"] == password);
  }

  /// إنشاء جلسات بشكل عشوائي مع تحديد المدة الزمنية (ساعة ونصف لكل جلسة)
  static Future<List<SessionModel>> getSessions(String userId) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التأخير

      // قائمة بالمواضيع المسبقة
      List<String> subjects = [
        "Android Development",
        "Algorithms",
        "Database Systems",
        "System Design",
        "Operating Systems",
        "Computer Interfaces",
      ];

      // خلط المواضيع لتكون الجلسات عشوائية
      subjects.shuffle(_random);

      // قائمة الجلسات النهائية
      List<SessionModel> sessions = [];
      int startHour = 9; // بداية الوقت: 9 صباحاً
      int startMinute = 0;

      for (int i = 0; i < min(subjects.length, 5); i++) {
        // وقت البداية
        String startTime =
            "${startHour % 12 == 0 ? 12 : startHour % 12}:${startMinute.toString().padLeft(2, '0')} ${startHour < 12 ? 'AM' : 'PM'}";

        // حساب وقت النهاية
        int endHour = startHour + (startMinute + 90) ~/ 60; // زيادة ساعة ونصف
        int endMinute = (startMinute + 90) % 60;
        String endTime =
            "${endHour % 12 == 0 ? 12 : endHour % 12}:${endMinute.toString().padLeft(2, '0')} ${endHour < 12 ? 'AM' : 'PM'}";

        // إضافة الجلسة إلى القائمة
        sessions.add(SessionModel(
          sessionName: subjects[i],
          time: "$startTime - $endTime",
        ));

        // تحديث وقت البداية للجلسة التالية
        startHour = endHour;
        startMinute = endMinute;
      }

      return sessions;
    } catch (e) {
      print("Error fetching sessions: $e");
      return [];
    }
  }

  /// استرداد المهام المتعلقة بمستخدم معين
  static Future<List<String>> getTasks(String userId) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التأخير
      return [
        "Task: Operating System for $userId",
        "Task: Mobile App for $userId",
        "Task: Algorithm for $userId",
      ];
    } catch (e) {
      print("Error fetching tasks: $e");
      return ["No tasks available for now."];
    }
  }

  /// استرداد الإعلانات
  static Future<List<String>> getAnnouncements() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التأخير
      return [
        "AI workshop this Friday!",
        "Hackathon scheduled next month.",
        "System maintenance on Sunday.",
      ];
    } catch (e) {
      print("Error fetching announcements: $e");
      return ["No announcements available."];
    }
  }

  static Future<List<String>> getdoctors() async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التأخير
      return [
        'Dr. Ahmed attia',
        'Dr. Rasha stohy',
        'Dr. gaber hassan',
        'Dr. Magdy abdelghany',
      ];
    } catch (e) {
      print("no: $e");
      return ["No available."];
    }
  }
}
