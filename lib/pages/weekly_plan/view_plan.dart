import 'package:flutter/material.dart';
import 'package:personal_finance/api/plan_api.dart';
import 'package:personal_finance/models/plan.dart';
import 'package:personal_finance/pages/weekly_plan/plan_detail.dart';

class ViewPlan extends StatelessWidget {
  const ViewPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
        title: const Text('Your Plan'),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: StreamBuilder<List<Plan>>(
        stream: getAllPlans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }

          List<Plan> plans = snapshot.data!;
          // sort based on the priority of the plan
          plans.sort((a, b) {
            if (a.priority == Priority.High && b.priority != Priority.High) {
              return -1;
            } else if (a.priority != Priority.High &&
                b.priority == Priority.High) {
              return 1;
            } else if (a.priority == Priority.Medium &&
                b.priority == Priority.Low) {
              return -1;
            } else if (a.priority == Priority.Low &&
                b.priority == Priority.Medium) {
              return 1;
            } else {
              return 0;
            }
          });

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              Plan plan = plans[index];
              return PlanDetail(plan: plan);
            },
          );
        },
      ),
    );
  }
}
