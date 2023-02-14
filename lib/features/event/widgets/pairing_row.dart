// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/models/player_model.dart';

class PairingRow extends StatefulWidget {
  List<PlayerModel>? pairing;
  PairingRow({this.pairing, super.key});

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
                  if (widget.pairing == null)
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
                            'TO: ${widget.pairing!.first.to}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'VP: ${widget.pairing!.first.vp}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'Primary: ${widget.pairing!.first.primary}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'TO opponents: ${widget.pairing!.first.toOpponents}',
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
                    enabled: widget.pairing == null,
                    style: AppStyles.textStyle.copyWith(color: Colors.white),
                    controller: secondPlayerController,
                    decoration: InputDecoration(
                        label: const Text('Second player'),
                        labelStyle: AppStyles.textStyle
                            .copyWith(color: Colors.grey[400])),
                  ),
                  if (widget.pairing == null)
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
                            'TO: ${widget.pairing!.last.to}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'VP: ${widget.pairing!.last.vp}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'Primary: ${widget.pairing!.last.primary}',
                            style: AppStyles.textStyle,
                          ),
                          Text(
                            'TO opponents: ${widget.pairing!.last.toOpponents}',
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
