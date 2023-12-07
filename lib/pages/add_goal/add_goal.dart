import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// Import your navigation bar components here
// import 'components/TopNavBar.dart';
// import 'components/BottomNavBar.dart';

class AddSavingGoalScreen extends StatefulWidget {
  @override
  _AddSavingGoalScreenState createState() => _AddSavingGoalScreenState();
}

class _AddSavingGoalScreenState extends State<AddSavingGoalScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timeToBuyController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCurrency = 'USD';

  XFile? _image; 

  // Method to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Saving Goal'),
        // Include top navigation bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Add the product\'s name',
                border: OutlineInputBorder(),
                // Add the rest styling
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                // Add the rest styling 
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                    timeToBuyController.text = "${selectedDate.toLocal()}".split(' ')[0];
                  });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: timeToBuyController,
                  decoration: InputDecoration(
                    labelText: 'Estimated time to buy',
                    border: OutlineInputBorder(),
                    // Add the rest of your styling here
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
                // Add the rest of your styling here
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Write notes',
                border: OutlineInputBorder(),
                // Add the rest of your styling here
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCurrency,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCurrency = newValue!;
                });
              },
              items: <String>['USD', 'GBP', 'EUR', 'INR']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
                // Add the rest of your styling here
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
              onPressed: () {
                // Add save logic
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0x990000ff),
                foregroundColor: Colors.white,
                padding: EdgeInsets.fromLTRB(17, 0, 16, 0),
                fixedSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
             ),
            ),
          ],
        ),
      ),
      // Include your bottom navigation bar
    );
  }
}

void main() => runApp(MaterialApp(home: AddSavingGoalScreen()));
