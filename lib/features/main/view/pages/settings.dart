// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:mta_app/features/main/view/I_page.dart';

class Settings extends StatelessWidget implements IPage {
  static const header = 'Settings';
  const Settings({super.key});

  @override
  String get pageHeader => header;

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      Icons.settings,
      size: 42,
    ));
  }
}
