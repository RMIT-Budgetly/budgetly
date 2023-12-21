import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/pages/weekly_plan/category_picker.dart';
import 'package:personal_finance/models/plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

var formatter = DateFormat.yMd();
var currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

class WeeklyPlanForm extends StatefulWidget {
  const WeeklyPlanForm({super.key});
  @override
  State<WeeklyPlanForm> createState() {
    return WeeklyPlanFormState();
  }
}

class WeeklyPlanFormState extends State<WeeklyPlanForm> {
  final _formKey = GlobalKey<FormState>();
  var _inputTaskName = '';
  var _inputBudget = '0';
  DateTime? _selectedDate;
  Category? _selectedCategory;
  Priority? _selectedPriority = Priority.High;
  final user = FirebaseAuth.instance.currentUser;

  void onDatePicker() async {
    DateTime now = DateTime.now();
    DateTime end = DateTime(now.year, now.month + 1, now.day);
    final chooseDate = await showDatePicker(
        context: context, initialDate: now, firstDate: now, lastDate: end);
    if (chooseDate != null) {
      setState(() {
        _selectedDate = chooseDate;
      });
    }
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

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var a = Plan(
        taskName: _inputTaskName,
        budget: double.tryParse(_inputBudget)!,
        date: _selectedDate!,
        category: _selectedCategory!,
        priority: _selectedPriority!,
      );
      FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('plans').add({
        'taskName': a.taskName,
        'budget': a.budget,
        'date': a.date,
        'category': a.category.name,
        'priority': a.priority.name,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Save successfully!'), 
          duration: Duration(seconds: 2),
          ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Weekly Plan",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Task Name',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1 ||
                      value.trim().length > 100) {
                    return 'Invalid Task Name. Please again';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _inputTaskName = newValue!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Budget',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'invalid budget!!';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _inputBudget = newValue!;
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: onDatePicker,
                          icon: const Icon(Icons.calendar_month),
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(_selectedDate == null
                            ? "Pick a date"
                            : formatter.format(_selectedDate!)), //
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: DropdownButtonFormField<Priority>(
                      value: _selectedPriority,
                      items: [
                        DropdownMenuItem(
                          value: Priority.High,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flag,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Priority.High.name,
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: Priority.Medium,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flag,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Priority.Medium.name,
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: Priority.Low,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flag,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                Priority.Low.name,
                              ),
                            ],
                          ),
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPriority = value;
                        });
                        // Perform any actions based on the selected priority level
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  // Open the Category Page
                  OutlinedButton(
                    onPressed: onShowCategoriesPicker,
                    child: Row(
                      children: [
                        _selectedCategory == null
                            ? const Icon(Icons.category)
                            : _selectedCategory!.getIcon(),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          _selectedCategory == null
                              ? "Category"
                              : (_selectedCategory!.name.length >
                                      12 // Set your maximum character count
                                  ? '${_selectedCategory!.name.substring(0, 12)}...' // Truncate text if longer than 15 characters
                                  : _selectedCategory!.name),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Display in a single line
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 17),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
