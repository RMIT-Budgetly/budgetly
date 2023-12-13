import 'package:flutter/material.dart';

class TrackingSection extends StatefulWidget {
  final String sectionName;
  final List<TrackingSectionItem> items;

  const TrackingSection(
      {super.key, required this.sectionName, this.items = const []});

  @override
  State<TrackingSection> createState() => _TrackingSectionState();
}

class _TrackingSectionState extends State<TrackingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.sectionName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
        ),
      ],
    );
  }
}

class TrackingSectionItem extends StatefulWidget {
  final String itemTitle;
  final int? amount;
  final double? progress;
  const TrackingSectionItem(
      {super.key, required this.itemTitle, this.amount = 0, this.progress = 0});

  @override
  State<TrackingSectionItem> createState() => _TrackingSectionItemState();
}

class _TrackingSectionItemState extends State<TrackingSectionItem> {
  int _amount = 0;
  double _progress = 0;

  void _changeAmount(int amount) {
    setState(() {
      _amount = amount;
    });
  }

  void _changeProgress(double progress) {
    // Check whether progress is is valid
    if (progress < 0 || progress > 1) {
      throw Exception('Progress must be between 0 and 1');
    }
    setState(() {
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                widget.itemTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              ),
            ],
          ),
          Text(
            _amount.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }
}
