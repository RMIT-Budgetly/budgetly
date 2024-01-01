import 'package:flutter/material.dart';
import 'package:personal_finance/models/goalModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GoalItemDetail extends StatefulWidget {
  const GoalItemDetail({Key? key, required this.model}) : super(key: key);
  final GoalModel model;

  @override
  _GoalItemDetailState createState() => _GoalItemDetailState();
}

class _GoalItemDetailState extends State<GoalItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
        title: const Text("Goal"),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: Column(
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
        ],
      ),
    );
  }
}
