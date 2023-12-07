import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarButton extends StatefulWidget {
  final Function(DateTime chosenDate)? onDateSelected;
  final DateTime initialDate;

  const CalendarButton({
    Key? key,
    this.onDateSelected,
    required this.initialDate,
  }) : super(key: key);

  @override
  _CalendarButtonState createState() => _CalendarButtonState();
}

class _CalendarButtonState extends State<CalendarButton> {
  DateTime? _chosenDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.calendar_today_rounded),
              onPressed: () async {
                final DateTime? chosenDate = await showDatePicker(
                  context: context,
                  initialDate: widget.initialDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (chosenDate != null) {
                  setState(() {
                    _chosenDate = chosenDate;
                  });
                }
                if (chosenDate != null && widget.onDateSelected != null) {
                  widget.onDateSelected!(chosenDate);
                } else if (widget.onDateSelected != null) {
                  widget.onDateSelected!(widget.initialDate);
                }
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _chosenDate != null
                    ? DateFormat('dd-MM-yyyy').format(_chosenDate!).toString()
                    : 'Select a date',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}