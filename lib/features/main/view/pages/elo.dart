// ignore_for_file: avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:mta_app/features/main/view/I_page.dart';

class Elo extends StatelessWidget implements IPage {
  static const header = 'ELO';
  const Elo({super.key});

  @override
  String get pageHeader => header;

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Icon(
      Icons.leaderboard,
      size: 42,
    ));
  }
}
