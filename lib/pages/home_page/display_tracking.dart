import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/pages/home_page/tracking_section.dart';

class DisplayTracking extends StatefulWidget {
  const DisplayTracking(
      {Key? key, required this.collectionName, required this.title})
      : super(key: key);
  final String collectionName;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _DisplayTrackingState();
  }
}

class _DisplayTrackingState extends State<DisplayTracking> {
  final user = FirebaseAuth.instance.currentUser;

  Stream<List<TrackingSectionItem>> streamSectionItems(String path) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(path)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.take(4)) // Take only the first 4 documents
        .asyncMap((docs) async {
      List<TrackingSectionItem> sectionItems = [];

      for (var doc in docs) {
        DocumentSnapshot document = await doc.reference.get();

        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          TrackingSectionItem sectionItem = TrackingSectionItem(
            itemTitle: data['productName'],
            amount: data['price'],
            progress: path == "goals" ? data['saved'] / data['price'] : null,
          );
          sectionItems.add(sectionItem);
        }
      }

      return sectionItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TrackingSectionItem>>(
      stream: streamSectionItems(widget.collectionName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            // Loading data process
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Set the stroke width
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor, // Set your desired color
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        } else {
          // Display your UI using the fetched data
          List<TrackingSectionItem> sectionItems = snapshot.data!;
          return TrackingSection(
            sectionName: widget.title,
            items: sectionItems,
          );
        }
      },
    );
  }
}
