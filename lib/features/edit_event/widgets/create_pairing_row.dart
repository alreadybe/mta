// ignore_for_file: avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

class CreatePairingRow extends StatefulWidget {
  final List<PlayerModel> appliedPlayers;
  final int tableNum;
  final Function callback;
  const CreatePairingRow(
      {required this.appliedPlayers,
      required this.tableNum,
      required this.callback,
      super.key});

  @override
  State<CreatePairingRow> createState() => _CreatePairingRowState();
}

class _CreatePairingRowState extends State<CreatePairingRow> {
  late PlayerModel player1;
  late PlayerModel player2;
  late List<PlayerModel> allPlayers;
  late PlayerModel hintPlayer;

  @override
  void initState() {
    hintPlayer = const PlayerModel(
        id: '000',
        userId: '000',
        firstname: 'Select',
        lastname: 'player',
        to: 0,
        vp: 0,
        primary: 0,
        toOpponents: 0);

    allPlayers = [hintPlayer, ...widget.appliedPlayers];
    player1 = hintPlayer;
    player2 = hintPlayer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: DropdownButton(
              isExpanded: true,
              style: AppStyles.textStyle,
              itemHeight: 60,
              dropdownColor: AppColors.lightDark,
              value: player1,
              items: [
                ...allPlayers.map(
                  (player) => DropdownMenuItem<PlayerModel>(
                    key: UniqueKey(),
                    value: player,
                    child: Text(
                        '${player.firstname} ${player.nickname ?? ''} ${player.lastname}'),
                  ),
                )
              ],
              onChanged: (item) {
                if (item != null) {
                  setState(() {
                    player1 = item;
                  });
                }
                if (player1.id != hintPlayer.id &&
                    player2.id != hintPlayer.id) {
                  final pairing = PairingModel(
                      player1: player1,
                      player2: player2,
                      table: widget.tableNum,
                      round: 1);
                  widget.callback(pairing);
                }
              },
            )),
        SizedBox(
          child: Column(
            children: [
              Text(
                'Table',
                style: AppStyles.textStyle,
              ),
              Text(
                widget.tableNum.toString(),
                style: AppStyles.textStyle,
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: DropdownButton(
            style: AppStyles.textStyle,
            itemHeight: 60,
            dropdownColor: AppColors.lightDark,
            value: player2,
            isExpanded: true,
            items: [
              ...allPlayers.map(
                (player) => DropdownMenuItem<PlayerModel>(
                  key: UniqueKey(),
                  value: player,
                  child: Text(
                      '${player.firstname} ${player.nickname ?? ''} ${player.lastname}'),
                ),
              )
            ],
            onChanged: (item) {
              if (item != null) {
                setState(() {
                  player2 = item;
                });
              }
              if (player1.id != hintPlayer.id && player2.id != hintPlayer.id) {
                final pairing = PairingModel(
                    player1: player1,
                    player2: player2,
                    table: widget.tableNum,
                    round: 1);
                widget.callback(pairing);
              }
            },
          ),
        ),
      ],
    );
  }
}
