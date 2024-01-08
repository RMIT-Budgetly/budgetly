import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:personal_finance/screens/add_expense_page/widgets/input_field.dart';
import "package:personal_finance/components/select_photo.dart";
import "package:personal_finance/components/submit_button.dart";
import 'package:personal_finance/models/category_model.dart';
import 'package:personal_finance/widgets/category_picker.dart';
import 'package:personal_finance/screens/add_expense_page/widgets/date_time_picker.dart';

final _firebase = FirebaseAuth.instance;

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  State<AddExpensesPage> createState() {
    return _AddExpensesPageState();
  }
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? reminderDate;
  Category? _selectedCategory;
  var inputBudget = '0';
  var note = "";

  void onSaved() async {
    _formKey.currentState!.save();
    if (_selectedCategory!.type == Type.Expense) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser!.uid)
          .collection('expenses')
          .add({
        'category': _selectedCategory!.name,
        'amount': double.tryParse(inputBudget),
        'description': note,
        'selectedDate': selectedDate,
        'reminderDate': reminderDate,
      });
    } else if (_selectedCategory!.type == Type.Income) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser!.uid)
          .collection('incomes')
          .add({
        'category': _selectedCategory!.name,
        'amount': double.tryParse(inputBudget),
        'description': note,
        'selectedDate': selectedDate,
        'reminderDate': reminderDate,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_firebase.currentUser!.uid)
          .collection('debts')
          .add({
        'category': _selectedCategory!.name,
        'amount': double.tryParse(inputBudget),
        'description': note,
        'selectedDate': selectedDate,
        'reminderDate': reminderDate,
      });
    }
  }

  void onBudgetInput(String value) {
    inputBudget = value;
  }

  void onNoteInput(String value) {
    note = value;
  }

  void onSelectedDate(DateTime value) {
    selectedDate = value;
  }

  void onReminderDate(DateTime value) {
    reminderDate = value;
  }

  void onShowCategoriesPicker() async {
    final selectedCategory = await showModalBottomSheet<Category>(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CategoryPicker(
          onCategorySelected: (category) {
            Navigator.pop(context, category); // Pass selected category back
          },
        );
      },
    );

    if (selectedCategory != null) {
      // Handle the selected category
      setState(() {
        _selectedCategory = selectedCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transactions"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Adjust the AppBar color
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCategoryButton(),
              InputField(
                prefixIcon: const Icon(Icons.monetization_on_outlined),
                hintText: "Amount",
                keyboardType: TextInputType.number,
                onSaveInputValue: onBudgetInput,
              ),
              InputField(
                prefixIcon: const Icon(Icons.note_add),
                hintText: "Description",
                onSaveInputValue: onNoteInput,
              ),
              DateTimePickerButton(
                initialDate: DateTime.now(),
                mode: DateTimePickerMode.date,
                icon: Icons.calendar_today,
                onDateTimeSelected: (onSelectedDate),
                label: "Choose a Date",
              ),
              DateTimePickerButton(
                initialDate: DateTime.now(),
                mode: DateTimePickerMode.date,
                icon: Icons.access_time_outlined,
                onDateTimeSelected: (onReminderDate),
                label: "Choose Reminder Date",
              ),
              const PhotoUploadButton(),
              const SizedBox(height: 20),
              SaveButton(onSaved: onSaved),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton() {
    return OutlinedButton(
      onPressed: onShowCategoriesPicker,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.deepPurple),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Adjust to fit content
        children: [
          _selectedCategory == null
              ? const Icon(Icons.category, color: Colors.deepPurple)
              : _selectedCategory!.getIcon(),
          const SizedBox(width: 10),
          Text(
            _selectedCategory == null
                ? "Select Category"
                : _selectedCategory!.name,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
