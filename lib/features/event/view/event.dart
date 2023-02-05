import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mta_app/const/assets/assets.gen.dart';
import 'package:mta_app/features/event/pages/final_page.dart';
import 'package:mta_app/features/event/pages/first_page.dart';
import 'package:mta_app/features/event/pages/second_page.dart';
import 'package:mta_app/features/event/pages/third_page.dart';

class Event extends StatefulWidget {
  const Event({super.key});

  static const routeName = 'edit_event';

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  late int index;
  late List<Widget> pages;

  @override
  void initState() {
    index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as EventArguments;

    pages = [
      FirstPage(eventId: args.eventId),
      SecondPage(eventId: args.eventId),
      ThirdPage(eventId: args.eventId),
      FinalPage(eventId: args.eventId),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.grey[800],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            print(args.eventId);
            setState(() {
              index = value;
            });
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.oneIcon.path,
                color: index == 0 ? Colors.white : Colors.grey[600],
              ),
              label: 'First',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.twoIcon.path,
                color: index == 1 ? Colors.white : Colors.grey[600],
              ),
              label: 'Second',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.threeIcon.path,
                color: index == 2 ? Colors.white : Colors.grey[600],
              ),
              label: 'Third',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Assets.svg.finalIcon.path,
                color: index == 3 ? Colors.white : Colors.grey[600],
              ),
              label: 'Result',
            ),
          ]),
      appBar: AppBar(
        title: const Text('Edit event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class EventArguments {
  final String eventId;

  EventArguments({required this.eventId});
}
