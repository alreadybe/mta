import 'package:flutter/material.dart';

class PairingRow extends StatefulWidget {
  const PairingRow({super.key});

  @override
  State<PairingRow> createState() => PairingRowState();
}

class PairingRowState extends State<PairingRow> {
  late TextEditingController firstPlayerController;
  late TextEditingController firstPlayerResultController;
  late TextEditingController secondPlayerController;
  late TextEditingController secondPlayerResultController;

  @override
  void initState() {
    super.initState();
    firstPlayerController = TextEditingController();
    firstPlayerResultController = TextEditingController();
    secondPlayerController = TextEditingController();
    secondPlayerResultController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: firstPlayerController,
              decoration: const InputDecoration(label: Text('First player')),
            ),
          ),
          Flexible(
            child: TextField(
              controller: firstPlayerResultController,
            ),
          ),
          Flexible(
            child: TextField(
              controller: secondPlayerController,
              decoration: const InputDecoration(label: Text('Second player')),
            ),
          ),
          Flexible(
            child: TextField(
              controller: secondPlayerResultController,
            ),
          ),
        ],
      ),
    );
  }
}
