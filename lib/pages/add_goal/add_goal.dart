import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddSavingGoalScreen extends StatefulWidget {
  @override
  _AddSavingGoalScreenState createState() => _AddSavingGoalScreenState();
}

class _AddSavingGoalScreenState extends State<AddSavingGoalScreen> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final timeToBuyController = TextEditingController();
  final urlController = TextEditingController();
  final notesController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Add Saving Goal', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      shadowColor: Theme.of(context).colorScheme.shadow,
      leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(productNameController, 'Add the product\'s name', Icons.shopping_cart),
          SizedBox(height: 10),
          _buildTextField(priceController, 'Price', Icons.attach_money),
          SizedBox(height: 10),
          _buildDateSelector(),
          SizedBox(height: 10),
          _buildTextField(urlController, 'URL', Icons.link),
          SizedBox(height: 10),
          _buildTextField(notesController, 'Write notes', Icons.note),
          SizedBox(height: 20),
          _buildImageUploadSection(),
          SizedBox(height: 20),
          _buildSaveButton(),
        ],
      ),
    );
  }

  TextField _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
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
            prefixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _image != null
            ? Image.file(File(_image!.path), fit: BoxFit.cover)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt, size: 50),
                  Text('Tap to upload an image of the product'),
                ],
              ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _saveGoal,
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  NavigationBar _buildNavigationBar() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Calendar'),
        NavigationDestination(icon: Icon(Icons.add_circle), label: 'Add'),
        NavigationDestination(icon: Icon(Icons.wallet), label: 'Wallet'),
        NavigationDestination(icon: Icon(Icons.perm_identity), label: 'Profile'),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _saveGoal() async {
    // Implement your saving logic here
    // After saving, clear the form
    productNameController.clear();
    priceController.clear();
    timeToBuyController.clear();
    urlController.clear();
    notesController.clear();
    setState(() {
      _image = null;
    });
  }
}

void main() => runApp(MaterialApp(home: AddSavingGoalScreen()));
