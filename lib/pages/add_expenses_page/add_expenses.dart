import "package:flutter/material.dart";
import "package:personal_finance/components/category_button.dart";
import "package:personal_finance/components/input_field.dart";
import 'package:personal_finance/components/calendar_button.dart';
import "package:personal_finance/components/select_photo.dart";
import "package:personal_finance/components/submit_button.dart";
import "package:personal_finance/pages/home_page/home.dart";

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  DateTime selectedDate = DateTime.now();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// class AddExpensesPage extends StatelessWidget {
//   const AddExpensesPage({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: <Widget>[
                    CategoryButton(
                      prefixIcon: const Icon(Icons.category_sharp),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                    ),
                    const InputField(
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: "0.00",
                      keyboardType: TextInputType.number,
                      // validator: null,
                    ),
                    const InputField(
                      prefixIcon: Icon(Icons.note_add),
                      hintText: "Write a note",
                    ),
                    CalendarButton(
                      initialDate: DateTime.now(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: const PhotoUploadButton(),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SaveButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
