import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var formatter = DateFormat.yMd();

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

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_inputTaskName);
      print(_inputBudget);
      print(_selectedDate);
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
              ElevatedButton(onPressed: onSubmit, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
