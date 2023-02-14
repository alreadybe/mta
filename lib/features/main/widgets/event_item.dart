import 'package:flutter/material.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/event/view/event.dart';
import 'package:mta_app/models/event_model.dart';

class EventItem extends StatelessWidget {
  final EventModel event;
  const EventItem({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Event.routeName),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[800]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.name,
                      style: AppStyles.textStyle
                          .copyWith(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Column(
                      children: [
                        Text(
                          '${event.date.toLocal().hour}:${event.date.toLocal().minute}',
                          style: AppStyles.textStyle.copyWith(fontSize: 12),
                        ),
                        Text(
                          '${event.date.toLocal().day}.${event.date.toLocal().month}.${event.date.toLocal().year}',
                          style: AppStyles.textStyle.copyWith(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${event.tours.toString()} туров',
                      style: AppStyles.textStyle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      '${event.pts.toString()} очков',
                      style: AppStyles.textStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
