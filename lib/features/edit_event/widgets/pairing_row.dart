// ignore_for_file: must_be_immutable, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/models/pairing_model.dart';

class PairingRow extends StatefulWidget {
  PairingModel pairing;
  bool isActiveTour;
  Function callback;
  PairingRow(
      {required this.pairing,
      required this.isActiveTour,
      required this.callback,
      super.key});

  @override
  State<PairingRow> createState() => PairingRowState();
}

class PairingRowState extends State<PairingRow> {
  late TextEditingController firstPlayerPrimaryResultController;
  late TextEditingController secondPlayerPrimaryResultController;

  late bool locked;

  @override
  void initState() {
    super.initState();
    locked = false;
    firstPlayerPrimaryResultController = TextEditingController();
    secondPlayerPrimaryResultController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final player1Name =
        '${widget.pairing.player1.firstname} ${widget.pairing.player1.nickname ?? ''} ${widget.pairing.player1.lastname}';

    final player2Name =
        '${widget.pairing.player2.firstname} ${widget.pairing.player2.nickname ?? ''} ${widget.pairing.player2.lastname}';

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 2 - 50,
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isActiveTour
                    ? Colors.grey[800]
                    : (widget.pairing.player1TO != null &&
                                widget.pairing.player2TO != null) &&
                            (widget.pairing.player1TO! >
                                widget.pairing.player2TO!)
                        ? Colors.green[900]
                        : (widget.pairing.player1TO != null &&
                                    widget.pairing.player2TO != null) &&
                                (widget.pairing.player1TO! ==
                                    widget.pairing.player2TO!)
                            ? Colors.yellow[900]
                            : Colors.red[900]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    player1Name,
                    style: AppStyles.textStyle.copyWith(fontSize: 16),
                  ),
                ),
                if (widget.isActiveTour)
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enabled: !locked,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        style: AppStyles.textStyle
                            .copyWith(color: Colors.white, fontSize: 24),
                        decoration: AppStyles.inputFieldStyle.copyWith(
                          labelText: 'Primary',
                        ),
                        controller: firstPlayerPrimaryResultController,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TO',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player1TO.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VP',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player1VP.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PR',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player1PRIM.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                'Table',
                style: AppStyles.textStyle,
              ),
              Text(
                widget.pairing.table.toString(),
                style: AppStyles.textStyle
                    .copyWith(fontSize: 21, color: AppColors.cyan),
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.isActiveTour)
                IconButton(
                    onPressed: () {
                      setState(() {
                        locked = !locked;
                      });
                      if (firstPlayerPrimaryResultController.text.isNotEmpty &&
                          secondPlayerPrimaryResultController.text.isNotEmpty) {
                        widget.callback(
                            result: widget.pairing.copyWith(
                                player1PRIM: int.parse(
                                    firstPlayerPrimaryResultController.text),
                                player2PRIM: int.parse(
                                    secondPlayerPrimaryResultController.text)),
                            isAdded: locked);
                      }
                    },
                    icon: Icon(
                      locked ? Icons.lock : Icons.lock_open,
                      color: locked ? AppColors.cyan : AppColors.white,
                    ))
            ],
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: widget.isActiveTour
                    ? Colors.grey[800]
                    : (widget.pairing.player1TO != null &&
                                widget.pairing.player2TO != null) &&
                            (widget.pairing.player2TO! >
                                widget.pairing.player1TO!)
                        ? Colors.green[900]
                        : (widget.pairing.player1TO != null &&
                                    widget.pairing.player2TO != null) &&
                                (widget.pairing.player2TO! ==
                                    widget.pairing.player1TO!)
                            ? Colors.yellow[900]
                            : Colors.red[900]),
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 2 - 50,
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    player2Name,
                    style: AppStyles.textStyle.copyWith(fontSize: 16),
                  ),
                ),
                if (widget.isActiveTour)
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        enabled: !locked,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        style: AppStyles.textStyle
                            .copyWith(color: Colors.white, fontSize: 24),
                        decoration: AppStyles.inputFieldStyle.copyWith(
                          labelText: 'Primary',
                        ),
                        controller: secondPlayerPrimaryResultController,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TO',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player2TO.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VP',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player2VP.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PR',
                              style: AppStyles.textStyle.copyWith(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.pairing.player2PRIM.toString(),
                              style: AppStyles.textStyle.copyWith(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
