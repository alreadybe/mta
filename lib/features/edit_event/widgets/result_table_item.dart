import 'package:flutter/material.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/models/player_model.dart';

class ResultTableItem extends StatelessWidget {
  final PlayerModel player;
  final int place;

  const ResultTableItem({required this.player, required this.place, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: place == 0
              ? Colors.amber[700]
              : place == 1
                  ? Colors.grey
                  : place == 2
                      ? Colors.brown
                      : AppColors.lightDark),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 - 20,
          child: Text(
            '${player.firstname}'
            '${player.nickname ?? ''} ${player.lastname}',
            style: AppStyles.textStyle.copyWith(fontSize: 18),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'TO',
            style: AppStyles.textStyle.copyWith(fontSize: 14),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            player.to.toString(),
            style: AppStyles.textStyle
                .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ]),
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
              player.vp.toString(),
              style: AppStyles.textStyle
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
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
              player.primary.toString(),
              style: AppStyles.textStyle
                  .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ]),
    );
  }
}
