import 'package:flutter/material.dart';
import 'package:mta_app/features/create_event/view/create_event.dart';
import 'package:mta_app/features/edit_event/view/edit_event.dart';

class MainPage extends StatelessWidget {
  static const routeName = 'main';

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Pairing app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: const Text('Create event'),
                  onPressed: () => Navigator.pushNamed(context, CreateEvent.routeName)),
              const SizedBox(height: 30),
              ElevatedButton(
                  child: const Text('Edit event'),
                  onPressed: () => Navigator.pushNamed(context, EditEvent.routeName)),
            ],
          ),
        ),
      ),
    );
  }
}
