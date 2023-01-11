import 'package:flutter/material.dart';

class EditEvent extends StatelessWidget {
  const EditEvent({super.key});

  static const routeName = 'edit_event';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
