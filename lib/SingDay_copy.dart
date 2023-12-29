import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final DateTime selectedDate;

  const NewPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务时间轴'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap with SingleChildScrollView
          child: VerticalTimeline(),
        ),
      ),
    );
  }
}

class VerticalTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(24, (hour) {
        return _TimelineItem(
          title: '任务$hour',
          description: '$hour:00 - ${(hour + 1) % 24}:00',
        );
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String description;

  const _TimelineItem({Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(description),
          ],
        ),
      ],
    );
  }
}
