// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:mta_app/features/main/view/I_page.dart';

class Stats extends StatelessWidget implements IPage {
  static const header = 'Stats';
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      Icons.hub_rounded,
      size: 42,
    ));
  }

  @override
  String get pageHeader => header;
}
