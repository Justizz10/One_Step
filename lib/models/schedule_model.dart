class ScheduleModel {
  final String scheduleId;
  final String userId;
  final String activityName;
  final DateTime scheduledDate;
  final int duration;
  final String intensity;
  String status;
  final String notes;

  ScheduleModel({
    required this.scheduleId,
    required this.userId,
    required this.activityName,
    required this.scheduledDate,
    required this.duration,
    required this.intensity,
    required this.status,
    this.notes = '',
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map, String id) {
    return ScheduleModel(
      scheduleId: id,
      userId: map['userId'] ?? '',
      activityName: map['activityName'] ?? '',
      scheduledDate: map['scheduledDate']?.toDate() ?? DateTime.now(),
      duration: map['duration'] ?? 0,
      intensity: map['intensity'] ?? 'medium',
      status: map['status'] ?? 'planned',
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'activityName': activityName,
      'scheduledDate': scheduledDate,
      'duration': duration,
      'intensity': intensity,
      'status': status,
      'notes': notes,
    };
  }
}