import 'package:flutter/material.dart';
import 'package:personal_finance/models/category.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum Priority {
  High,
  Medium,
  Low,
}

class Plan {
  Plan({
    required this.taskName,
    required this.budget,
    required this.date,
    required this.category,
    required this.priority,
  }) : id = uuid.v4();

  final String id;
  final String taskName;
  final double budget;
  final DateTime date;
  final Category category;
  final Priority priority;
}
