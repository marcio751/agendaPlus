import 'package:flutter/material.dart';

enum TaskStatus { pending, almostDue, overdue, completed }

class Task {
  Task({
    this.id,
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.completed = false,
  });

  final int? id;
  final String title;
  final String description;
  final DateTime? date;
  final TimeOfDay? time;
  bool completed;

  DateTime? get dueDateTime {
    if (date == null) return null;
    if (time == null) {
      return DateTime(date!.year, date!.month, date!.day);
    }
    return DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
  }

  String get formattedDate {
    if (date == null) return 'Sem data';
    return '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}';
  }

  TaskStatus get status {
    if (completed) return TaskStatus.completed;

    final due = dueDateTime;
    if (due == null) return TaskStatus.pending;

    final now = DateTime.now();
    if (due.isBefore(now)) return TaskStatus.overdue;
    if (due.isBefore(now.add(const Duration(hours: 1)))) return TaskStatus.almostDue;
    return TaskStatus.pending;
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.completed:
        return 'Concluída';
      case TaskStatus.almostDue:
        return 'Quase atrasada';
      case TaskStatus.overdue:
        return 'Atrasada';
      case TaskStatus.pending:
        return 'Pendente';
    }
  }

  Color get statusColor {
    switch (status) {
      case TaskStatus.completed:
        return const Color(0xFF2ECC71);
      case TaskStatus.almostDue:
        return const Color(0xFFF39C12);
      case TaskStatus.overdue:
        return const Color(0xFFE74C3C);
      case TaskStatus.pending:
        return const Color(0xFFF1C40F);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'date': date?.millisecondsSinceEpoch,
      'time': time != null ? time!.hour * 60 + time!.minute : null,
      'completed': completed ? 1 : 0,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      completed: completed ?? this.completed,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    final dateVal = map['date'];
    final timeVal = map['time'];
    return Task(
      id: map['id'] as int?,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: dateVal != null ? DateTime.fromMillisecondsSinceEpoch(dateVal as int) : null,
      time: timeVal != null ? TimeOfDay(hour: (timeVal as int) ~/ 60, minute: (timeVal) % 60) : null,
      completed: (map['completed'] ?? 0) == 1,
    );
  }
}
