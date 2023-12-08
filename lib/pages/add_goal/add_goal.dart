import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path; // For extracting file name from path
// Firebase imports
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
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

  XFile? _image;

  // Method to handle image selection
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> saveGoal() async {
    // Collecting data from the fields
    String productName = productNameController.text;
    String price = priceController.text;
    String timeToBuy = timeToBuyController.text;
    String url = urlController.text;
    String notes = notesController.text;
    String? imagePath = _image?.path;

    // TODO: Upload the image to Firebase Storage and get the URL
    String imageUrl = ''; // Placeholder for image URL
    if (imagePath != null) {
      // Upload logic goes here
      // FirebaseStorage storage = FirebaseStorage.instance;
      // String fileName = path.basename(imagePath);
      // Reference ref = storage.ref().child('product_images/$fileName');
      // UploadTask uploadTask = ref.putFile(File(imagePath));
      // imageUrl = await (await uploadTask).ref.getDownloadURL();
    }

    // TODO: Save data to Firebase Database
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    // firestore.collection('saving_goals').add({
    //   'product_name': productName,
    //   'price': price,
    //   'time_to_buy': timeToBuy,
    //   'url': url,
    //   'notes': notes,
    //   'selected_date': selectedDate.toString(),
    //   'image_url': imageUrl,
    // });

    // Clear the fields after saving
    productNameController.clear();
    priceController.clear();
    timeToBuyController.clear();
    urlController.clear();
    notesController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Saving Goal'),
        // Include top navigation bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product name field
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                labelText: 'Add the product\'s name',
                prefixIcon: Icon(Icons.shopping_cart),
                border: OutlineInputBorder(),
                // Add the rest styling
              ),
            ),
            SizedBox(height: 10),
            // Price field
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
                // Add the rest styling
              ),
            ),
            // Time selection field
            // Time selection field
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
                    timeToBuyController.text =
                        "${selectedDate.toLocal()}".split(' ')[0];
                  });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: timeToBuyController,
                  decoration: InputDecoration(
                    labelText: 'Estimated time to buy',
                    prefixIcon: Icon(
                        Icons.calendar_today), // Add the calendar icon here
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
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
                // Add the rest of your styling here
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: 'Write notes',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
                // Add the rest of your styling here
              ),
            ),
            SizedBox(height: 20),
            // Image upload section
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150, // Set a fixed height for image container
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image != null
                    ? Image.file(File(_image!.path))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt,
                              size: 50), // Icon for image upload
                          Text('Tap to upload an image of the product'),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: saveGoal,
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
                        borderRadius: BorderRadius.circular(20))),
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
