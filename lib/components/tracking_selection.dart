import 'package:flutter/material.dart';

class TrackingSelection extends StatelessWidget {
  const TrackingSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Tracking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createButton(
                    const Icon(Icons.add),
                    'Add Expenses',
                    () {
                      Navigator.pushNamed(context, '/add_expenses');
                    },
                  ),
                  createButton(
                    const Icon(Icons.add),
                    'Add Income',
                    () {
                      Navigator.pushNamed(context, '/add_income');
                    },
                  ),
                  createButton(
                    const Icon(Icons.add),
                    'Add Saving Goal',
                    () {
                      Navigator.pushNamed(context, '/saving_goal');
                    },
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     createButton(
              //       const Icon(Icons.add),
              //       'Add Weekly Plan',
              //       () {
              //         Navigator.pushNamed(context, '/weekly_plan_form');
              //       },
              //     ),
              //     createButton(
              //       const Icon(Icons.add),
              //       'Add Saving Goal',
              //       () {
              //         Navigator.pushNamed(context, '/saving_goal');
              //       },
              //     ),
              //   ],
              // ),
            ],
          )),
    );
  }

  Widget createButton(Icon image, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            image,
            const SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
