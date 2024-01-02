import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/api/plan_api.dart';
import 'package:personal_finance/models/plan.dart';

final user = FirebaseAuth.instance.currentUser;

class PlanDetail extends StatelessWidget {
  const PlanDetail({super.key, required this.plan});
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    void onCompletePlan() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to complete this plan?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .collection('expenses')
                      .add({
                    'category': plan.category.name,
                    'amount': plan.budget,
                    'description': plan.taskName,
                    'selectedDate': plan.date,
                    'reminderDate': plan.date
                  });
                  deletePlan(plan.id);
                  Navigator.pop(context);
                },
                child: const Text('Complete'),
              ),
            ],
          );
        },
      );
    }

    void onDeletePlan() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text('Are you sure you want to delete this plan?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  deletePlan(plan.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.taskName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0x7F0000FF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.flag,
                        color: plan!.priority == Priority.High
                            ? Colors.red
                            : plan!.priority == Priority.Medium
                                ? Colors.yellow
                                : Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "\$${plan.budget}",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 149, 206, 154),
                      shape: const CircleBorder(
                          eccentricity: 0.2,
                          side: BorderSide(
                            color: Color.fromARGB(255, 140, 212, 146),
                            width: 1,
                            style: BorderStyle.solid,
                          )), // Circle shape for the button
                    ),
                    onPressed: () {
                      onCompletePlan();
                    },
                    child: const Icon(
                      Icons.check,
                      color: Color.fromARGB(255, 50, 158, 53),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 243, 190, 186),
                      shape: const CircleBorder(
                          eccentricity: 0.2,
                          side: BorderSide(
                            color: Color.fromARGB(255, 243, 190, 186),
                            width: 1,
                            style: BorderStyle.solid,
                          )), // Circle shape for the button
                    ),
                    onPressed: () {
                      onDeletePlan();
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
