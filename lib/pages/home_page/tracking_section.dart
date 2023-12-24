import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TrackingSection extends StatefulWidget {
  final String sectionName;
  final List<TrackingSectionItem> items;

  const TrackingSection(
      {super.key,
      required this.sectionName,
      this.items = const <TrackingSectionItem>[]});

  @override
  State<TrackingSection> createState() => _TrackingSectionState();
}

class _TrackingSectionState extends State<TrackingSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          StaggeredGrid.count(
              crossAxisCount: 2,
              axisDirection: AxisDirection.down,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: widget.items),
        ],
      ),
    );
  }
}

class TrackingSectionItem extends StatefulWidget {
  final String itemTitle;
  final double? amount;
  final double? progress;
  const TrackingSectionItem(
      {super.key, required this.itemTitle, this.amount, this.progress});

  @override
  State<TrackingSectionItem> createState() => _TrackingSectionItemState();
}

class _TrackingSectionItemState extends State<TrackingSectionItem> {
  double _amount = 0;
  double _progress = 0;

  void _changeAmount(double amount) {
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.black.withOpacity(0.4),
      elevation: 4,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Ink(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemTitle,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  // const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              Text(
                "\$${widget.amount}",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(
                height: 8,
              ),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFE0533D)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
