// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

class PairingRow extends StatefulWidget {
  List<PlayerModel>? pairing;
  PairingModel? currentPairing;
  PairingRow({this.pairing, this.currentPairing, super.key});

  @override
  State<PairingRow> createState() => PairingRowState();
}

class PairingRowState extends State<PairingRow> {
  late TextEditingController firstPlayerController;
  late TextEditingController firstPlayerPrimaryResultController;
  late TextEditingController secondPlayerController;
  late TextEditingController secondPlayerPrimaryResultController;

  @override
  void initState() {
    super.initState();
    firstPlayerController =
        TextEditingController(text: widget.pairing?.first.name);
    firstPlayerPrimaryResultController = TextEditingController();
    secondPlayerController =
        TextEditingController(text: widget.pairing?.last.name);
    secondPlayerPrimaryResultController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.grey[800]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8),
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      enabled: widget.pairing == null,
                      style: AppStyles.textStyle.copyWith(color: Colors.white),
                      controller: firstPlayerController,
                      decoration: AppStyles.inputFieldStyle.copyWith(
                          label: const Text('First player'),
                          labelStyle: AppStyles.textStyle
                              .copyWith(color: Colors.grey[400]))),
                  if (widget.currentPairing == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          child: TextField(
                            style: AppStyles.textStyle
                                .copyWith(color: Colors.white),
                            decoration: InputDecoration(
                                label: const Text('Primary'),
                                labelStyle: AppStyles.textStyle
                                    .copyWith(color: Colors.grey[400])),
                            controller: firstPlayerPrimaryResultController,
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TO: ${widget.currentPairing!.toRes.first}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'VP: ${widget.currentPairing!.vpRes.first}',
                            style: AppStyles.textStyle,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 8),
              width: MediaQuery.of(context).size.width / 2 - 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    enabled: widget.currentPairing == null,
                    style: AppStyles.textStyle.copyWith(color: Colors.white),
                    controller: secondPlayerController,
                    decoration: InputDecoration(
                        label: const Text('Second player'),
                        labelStyle: AppStyles.textStyle
                            .copyWith(color: Colors.grey[400])),
                  ),
                  if (widget.currentPairing == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          child: TextField(
                            style: AppStyles.textStyle
                                .copyWith(color: Colors.white),
                            decoration: InputDecoration(
                                label: const Text('Primary'),
                                labelStyle: AppStyles.textStyle
                                    .copyWith(color: Colors.grey[400])),
                            controller: secondPlayerPrimaryResultController,
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TO: ${widget.currentPairing!.toRes.last}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'VP: ${widget.currentPairing!.vpRes.last}',
                            style: AppStyles.textStyle,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
