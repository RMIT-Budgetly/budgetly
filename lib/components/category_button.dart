import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon? prefixIcon;
  const CategoryButton({
    Key? key,
    required this.onPressed,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //     color: Colors.black38,
      //     width: 1,
      //   ),
      //   borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      // ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IconButton(
              icon: prefixIcon ?? const Icon(Icons.category),
              color: Colors.black,
              onPressed: onPressed,
              constraints: prefixIcon == null
                  ? const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    )
                  : const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
            ),
          ),
          const Expanded(
              flex: 5,
              child: Text("Select Category",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )))
        ],
      ),
    );
  }
}
