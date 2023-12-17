import "package:flutter/material.dart";
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:personal_finance/components/add_contacts.dart";
import "package:personal_finance/components/input_field.dart";
import 'package:personal_finance/components/calendar_button.dart';
import "package:personal_finance/components/reminder_button.dart";
import "package:personal_finance/components/select_photo.dart";
import "package:personal_finance/components/submit_button.dart";
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/pages/add_expenses_page/category_picker.dart';

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? reminderDate;
  Category? _selectedCategory;
  List<Contact> _contacts = [];
  var inputBudget = '0';
  var note = "";
  void _onContactSelected(List<Contact> contacts) {
    // Handle selected contacts
    setState(() {
      _contacts = contacts;
    });
  }

  void onSaved() {
    _formKey.currentState!.save();
    print(_selectedCategory!.name);
    print(double.tryParse(inputBudget));
    print(note);
    print(selectedDate);
    print(reminderDate);
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
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: PageView(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: <Widget>[
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
                                            20 // Set your maximum character count
                                        ? '${_selectedCategory!.name.substring(0, 12)}...' // Truncate text if longer than 15 characters
                                        : _selectedCategory!.name),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1, // Display in a single line
                              ),
                            ],
                          ),
                        ),
                        InputField(
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          hintText: "budget",
                          keyboardType: TextInputType.number,
                          onSaveInputValue: onBudgetInput,
                          // validator: null,
                        ),
                        InputField(
                          prefixIcon: Icon(Icons.note_add),
                          hintText: "Write a note",
                          onSaveInputValue: onNoteInput,
                        ),
                        CalendarButton(
                          onDateSelected: onSelectedDate,
                          initialDate: DateTime.now(),
                        ),
                        ReminderButton(
                          initialDate: DateTime.now(),
                          onDateSelected: onReminderDate,
                        ),
                        AddContactButton(
                          onContactSelected: _onContactSelected,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: const PhotoUploadButton(),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Column(
                      children: <Widget>[
                        SaveButton(onSaved: onSaved),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
