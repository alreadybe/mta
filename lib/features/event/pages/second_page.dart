import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String eventId;
  const SecondPage({required this.eventId, super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('SecondPage'),
    );
  }
}
