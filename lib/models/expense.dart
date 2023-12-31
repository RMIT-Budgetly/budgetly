import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final double? amount;
  final String? category;
  final String? description;
  final DateTime? reminderDate;
  final DateTime? selectedDate;

  Expense({
    this.amount,
    this.category,
    this.description,
    this.reminderDate,
    this.selectedDate,
  });

  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
