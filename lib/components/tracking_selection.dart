import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    "",
                    'Add Transactions',
                    () {
                      Navigator.pushNamed(context, '/add_expenses');
                    },
                  ),
                  // createButton(
                  //   const Icon(Icons.add),
                  //   'Add Income',
                  //   () {
                  //     Navigator.pushNamed(context, '/add_income');
                  //   },
                  // ),
                  // createButton(
                  //   const Icon(Icons.add),
                  //   'Add Saving Goal',
                  //   () {
                  //     Navigator.pushNamed(context, '/add_goal');
                  //   },
                  // ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  createButton(
                    "",
                    'Add Weekly Plan',
                    () {
                      Navigator.pushNamed(context, '/weekly_plan_form');
                    },
                  ),
                  createButton(
                    "",
                    'Add Saving Goal',
                    () {
                      Navigator.pushNamed(context, '/add_goal');
                    },
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget createButton(String imagePath, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: 110,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(left: 2, right: 2),
        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(imagePath, width: 50),
              const SizedBox(height: 10),
              Text(text, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
