import 'package:flutter/material.dart';

class DiaryCardWidget extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  const DiaryCardWidget({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                Text(content, style: const TextStyle(color: Colors.white)),
                Text(date, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
