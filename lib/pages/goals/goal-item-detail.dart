import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/api/goal-api.dart';
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/models/goalModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/pages/home_page/home.dart';

final user = FirebaseAuth.instance.currentUser;

class GoalItemDetail extends StatefulWidget {
  const GoalItemDetail({Key? key, required this.model, required this.color})
      : super(key: key);
  final GoalModel model;
  final Color color;

  @override
  _GoalItemDetailState createState() => _GoalItemDetailState();
}

class _GoalItemDetailState extends State<GoalItemDetail> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController savedMoney = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    savedMoney.dispose();
  }

  void handleUpdateGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save money to complete this goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Wallet: ${HomePage.totalMoney}\$",
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 16,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: savedMoney,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Enter a number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    } else {
                      int? enteredValue = int.tryParse(value);
                      if (enteredValue == null) {
                        return 'Please enter a valid number';
                      } else if (enteredValue > HomePage.totalMoney) {
                        return 'You have exceeded the total amount of your wallet. Please enter a smaller number';
                      } else {
                        return null;
                      }
                    }
                  },
                  onSaved: (newValue) {
                    savedMoney.text = newValue!;
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Call a function to print "hi" with the obtained number
                onSubmit();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void onSubmit() {
    _formKey.currentState!.save();
    int number = int.tryParse(savedMoney.text) ?? 0;
    if (_formKey.currentState!.validate()) {
      setState(() {
        // update locally
        widget.model.saved += number;
        savedMoney.text = "";
      });
      // update the database
      updateGoalProcess(widget.model.goalId, widget.model.saved);
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('expenses')
          .add({
        'category':
            categories.where((element) => element.name == "Goal").first.name,
        'amount': number.toDouble(),
        'description': "Save money for ${widget.model.productName}",
        'selectedDate': DateTime.now(),
        'reminderDate': DateTime.now(),
      });
      Navigator.of(context).pop();
    } else {
      // ignore: avoid_print
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    Text savedContent = Text(
      widget.model.saved.toStringAsFixed(2),
      style: const TextStyle(color: const Color.fromARGB(255, 250, 94, 83)),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
        title: const Text("Goal"),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.model.imagePath! != ""
                  ? widget.model.imagePath!
                  : "https://i.pinimg.com/originals/18/69/a4/1869a46592cbd3d0f9837ad6d3644cea.jpg",
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'Product: ${widget.model.productName}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'Price: \$${widget.model.price}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'Expected Date: ${DateFormat('dd-MM-yyyy').format(widget.model.timeToBuy)}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'External Link: ${widget.model.url}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "\$${widget.model.saved.toStringAsFixed(2)}/\$${widget.model.price.toStringAsFixed(2)}",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                LinearProgressIndicator(
                  minHeight: 20,
                  borderRadius: BorderRadius.circular(10),
                  value: widget.model.saved / widget.model.price,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                ),
              ]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                handleUpdateGoal();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(380, 40),
              ),
              child: const Text("Update Goal"),
            ),
          ],
        ),
      ),
    );
  }
}
