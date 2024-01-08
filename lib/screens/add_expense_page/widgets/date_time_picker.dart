import 'package:flutter/material.dart';

enum DateTimePickerMode { date, dateTime }

class DateTimePickerButton extends StatefulWidget {
  final DateTime initialDate;
  final DateTimePickerMode mode;
  final Function(DateTime)? onDateTimeSelected;
  final IconData icon;
  final String label; // New custom label parameter

  const DateTimePickerButton({
    Key? key,
    required this.initialDate,
    required this.onDateTimeSelected,
    this.mode = DateTimePickerMode.date,
    this.icon = Icons.calendar_today_rounded,
    this.label = 'Select Date', // Default label
  }) : super(key: key);

  @override
  _DateTimePickerButtonState createState() => _DateTimePickerButtonState();
}

class _DateTimePickerButtonState extends State<DateTimePickerButton> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDateTime() async {
    final DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (chosenDate != null && widget.mode == DateTimePickerMode.dateTime) {
      final TimeOfDay? chosenTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (chosenTime != null) {
        setState(() {
          _selectedDate = DateTime(
            chosenDate.year,
            chosenDate.month,
            chosenDate.day,
            chosenTime.hour,
            chosenTime.minute,
          );
          _selectedTime = chosenTime;
        });
      }
    } else if (chosenDate != null) {
      setState(() {
        _selectedDate = chosenDate;
      });
    }

    if (_selectedDate != null && widget.onDateTimeSelected != null) {
      widget.onDateTimeSelected!(_selectedDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = widget.label; // Use the custom label
    final hintColor = _selectedDate != null
        ? Colors.black // Color when date and/or time are selected
        : Colors.black38; // Color when date and/or time are not selected

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            child: IconButton(
              icon: Icon(widget.icon, size: 20),
              color: Colors.black,
              onPressed: _selectDateTime,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: _selectDateTime,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 14, color: hintColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
