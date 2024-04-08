import 'package:flutter/material.dart';

abstract class MyStep extends StatelessWidget {
  const MyStep({
    super.key,
    required this.title,
    required this.content,
  });

  final String Function(BuildContext context) title;
  final Widget Function(BuildContext context) content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: content(context),
            ),
          ),
        ),
      ],
    );
  }
}
