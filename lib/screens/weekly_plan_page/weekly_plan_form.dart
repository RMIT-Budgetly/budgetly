import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/widgets/category_picker.dart';
import 'package:personal_finance/models/plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('plans')
          .add({
        'productName': _inputTaskName,
        'price': double.tryParse(_inputBudget)!,
        'date': _selectedDate!,
        'category': _selectedCategory!,
        'priority': _selectedPriority!,
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
        title: const Text("Weekly Plan",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 23)),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TaskNameField(
                onSaved: (newValue) => _inputTaskName = newValue!,
              ),
              BudgetField(
                onSaved: (newValue) => _inputBudget = newValue!,
              ),
              DatePickerRow(
                selectedDate: _selectedDate,
                onDatePicker: onDatePicker,
              ),
              PriorityPicker(
                selectedPriority: _selectedPriority,
                onPriorityChanged: (newValue) =>
                    setState(() => _selectedPriority = newValue),
              ),
              CategoryButton(
                selectedCategory: _selectedCategory,
                onShowCategoriesPicker: onShowCategoriesPicker,
              ),
              ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                child: const Text("Save", style: TextStyle(fontSize: 17)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskNameField extends StatelessWidget {
  final Function(String?) onSaved;

  const TaskNameField({Key? key, required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          border: InputBorder.none, hintText: 'Task Name'),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            value.trim().length == 1 ||
            value.trim().length > 100) {
          return 'Invalid Task Name. Please again';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}

class BudgetField extends StatelessWidget {
  final Function(String?) onSaved;

  const BudgetField({Key? key, required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration:
          const InputDecoration(hintText: 'Budget', border: InputBorder.none),
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            int.tryParse(value) == null ||
            int.tryParse(value)! <= 0) {
          return 'Invalid budget!';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}

class DatePickerRow extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDatePicker;

  const DatePickerRow({Key? key, this.selectedDate, required this.onDatePicker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat.yMd();

    return Row(
      children: [
        IconButton(
          onPressed: onDatePicker,
          icon: const Icon(Icons.calendar_month),
          color: Theme.of(context).primaryColor,
        ),
        Text(selectedDate == null
            ? "Pick a date"
            : formatter.format(selectedDate!)),
      ],
    );
  }
}

class PriorityPicker extends StatelessWidget {
  final Priority? selectedPriority;
  final ValueChanged<Priority?> onPriorityChanged;

  const PriorityPicker(
      {Key? key, this.selectedPriority, required this.onPriorityChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Priority>(
      value: selectedPriority,
      items: Priority.values.map((priority) {
        return DropdownMenuItem(
          value: priority,
          child: Row(
            children: [
              Icon(Icons.flag, color: _getPriorityColor(priority)),
              const SizedBox(width: 8),
              Text(priority.name),
            ],
          ),
        );
      }).toList(),
      onChanged: onPriorityChanged,
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.yellow;
      case Priority.Low:
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}

class CategoryButton extends StatelessWidget {
  final Category? selectedCategory;
  final VoidCallback onShowCategoriesPicker;

  const CategoryButton(
      {Key? key, this.selectedCategory, required this.onShowCategoriesPicker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onShowCategoriesPicker,
      child: Row(
        children: [
          selectedCategory == null
              ? const Icon(Icons.category)
              : selectedCategory!.getIcon(),
          const SizedBox(width: 6),
          Text(
            selectedCategory == null
                ? "Category"
                : (selectedCategory!.name.length > 12
                    ? '${selectedCategory!.name.substring(0, 12)}...'
                    : selectedCategory!.name),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
