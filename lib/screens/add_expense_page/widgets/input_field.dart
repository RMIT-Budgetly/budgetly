import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  Icon? prefixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final DateTime? selectedDate;
  final String Function(String?)? validator; // Updated type for validator
  final Function(String value) onSaveInputValue;

  InputField({
    Key? key,
    Icon? prefixIcon,
    this.hintText,
    this.keyboardType,
    this.selectedDate,
    this.validator, // Updated parameter
    this.onTap,
    required this.onSaveInputValue,
  })  : prefixIcon = prefixIcon != null ? Icon(prefixIcon.icon, size: 20) : null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        if (prefixIcon != null)
          Container(
            constraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            child: prefixIcon,
          ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: TextFormField(
              onTap: onTap,
              validator: validator, // Directly use validator
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.black38,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onSaved: (value) => onSaveInputValue(value!),
            ),
          ),
        ),
      ]),
    );
  }
}
