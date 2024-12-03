class SessionModel {
  final String sessionName;
  final String time;

  SessionModel({required this.sessionName, required this.time});

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionName: json['session_name'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_name': sessionName,
      'time': time,
    };
  }
}
