import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  String? imagePath;
  String? notes; // Make this property nullable
  double price;
  int saved;
  String productName;
  DateTime timeToBuy;
  String? url;

  GoalModel({
    this.imagePath,
    this.notes,
    required this.price,
    required this.saved,
    required this.productName,
    required this.timeToBuy,
    this.url,
  });

  static DateTime convertTimestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }
}
