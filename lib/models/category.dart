import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum Type { Expense, Income, Debts }

class Category {
  Category({
    required this.name,
    required this.iconData,
    required this.type,
  }) : id = uuid.v4();
  final String id;
  final String name;
  final int iconData;
  final Type type;

  Icon getIcon() {
    return Icon(
      IconData(
        iconData,
        fontFamily: 'MaterialIcons', // Assuming it's a Material icon
      ),
    );
  }
}

var categories = [
  Category(
    name: "Food & Beverage",
    iconData: Icons.fastfood.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Shopping",
    iconData: Icons.shopping_bag_sharp.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Transportation",
    iconData: Icons.motorcycle.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Bills",
    iconData: Icons.receipt.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Healthcare",
    iconData: Icons.medical_information.codePoint,
    type: Type.Expense,
  ),
  Category(
    name: "Salary",
    iconData: Icons.attach_money.codePoint,
    type: Type.Income,
  ),
  Category(
    name: "Loan",
    iconData: Icons.confirmation_number_sharp.codePoint,
    type: Type.Debts,
  )
];
