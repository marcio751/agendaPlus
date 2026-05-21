import 'package:flutter/material.dart';

enum TaskStatus { pending, almostDue, overdue, completed }

class Task {
  Task({
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.completed = false,
  });

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
}
