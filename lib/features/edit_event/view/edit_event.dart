// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart';
import 'package:mta_app/features/edit_event/widgets/pairing_row.dart';
import 'package:mta_app/features/edit_event/widgets/result_table_item.dart';
import 'package:mta_app/models/event_model.dart';
import 'package:mta_app/models/pairing_model.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key});

  static const routeName = 'edit_event';

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late EditEventBloc _eventBloc;
  late List<PairingModel> tourResult;
  late int currentIndexFinal;

  @override
  void initState() {
    tourResult = [];
    _eventBloc = context.read();
    currentIndexFinal = 0;
    super.initState();
  }

  void onItemTapped(int index, int activeTour, EventModel event) {
    if (index + 1 <= activeTour) {
      currentIndexFinal = index;
      _eventBloc.add(EditEventEvent.selectTour(tour: index + 1, event: event));
    }
  }

  void resultPairingCallback(
      {required PairingModel result, required bool isAdded}) {
    if (isAdded) {
      tourResult.add(result);
    } else {
      tourResult.remove(result);
    }
  }

  List<BottomNavigationBarItem> rounds = const [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.looks_one_outlined,
        ),
        label: '1'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.looks_two_outlined,
        ),
        label: '2'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.looks_3_outlined,
        ),
        label: '3'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.looks_4_outlined,
        ),
        label: '4'),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.looks_5_outlined,
        ),
        label: '5'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEventBloc, EditEventState>(
      listener: (context, state) {
        state.mapOrNull(
          eventFinished: (value) => currentIndexFinal = value.event.tours,
        );
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              bottomNavigationBar: state.maybeMap(
                  orElse: () => const SizedBox(),
                  eventFinished: (value) => BottomNavigationBar(
                          selectedLabelStyle: AppStyles.textStyle
                              .copyWith(color: AppColors.white),
                          selectedIconTheme:
                              IconThemeData(color: AppColors.cyan),
                          unselectedLabelStyle: AppStyles.textStyle,
                          selectedItemColor: AppColors.white,
                          backgroundColor: AppColors.lightDark,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          unselectedItemColor: AppColors.white,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: currentIndexFinal,
                          onTap: (index) => onItemTapped(
                              index, value.event.activeTour, value.event),
                          items: [
                            ...rounds.sublist(0, value.event.tours),
                            const BottomNavigationBarItem(
                                label: 'final',
                                icon: Icon(
                                  Icons.list_alt_outlined,
                                ))
                          ]),
                  loaded: (value) => BottomNavigationBar(
                          selectedLabelStyle: AppStyles.textStyle
                              .copyWith(color: AppColors.white),
                          selectedIconTheme:
                              IconThemeData(color: AppColors.cyan),
                          unselectedLabelStyle: AppStyles.textStyle,
                          selectedItemColor: AppColors.white,
                          backgroundColor: AppColors.lightDark,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          unselectedItemColor: AppColors.white,
                          type: BottomNavigationBarType.fixed,
                          currentIndex: value.tour - 1,
                          onTap: (index) => onItemTapped(
                              index, value.event.activeTour, value.event),
                          items: [
                            ...rounds.sublist(0, value.event.tours),
                            const BottomNavigationBarItem(
                                label: 'final',
                                icon: Icon(
                                  Icons.list_alt_outlined,
                                ))
                          ])),
              backgroundColor: AppColors.dark,
              body: state.maybeMap(
                  orElse: () => Center(
                        child: CircularProgressIndicator(color: AppColors.red),
                      ),
                  eventFinished: (value) => SingleChildScrollView(
                        child: Column(
                            children: value.result
                                .asMap()
                                .entries
                                .map((e) => ResultTableItem(
                                      player: e.value,
                                      place: e.key,
                                    ))
                                .toList()),
                      ),
                  loaded: (value) {
                    final tourPairings = value.event.eventPairings!
                        .where((e) => e.round == value.tour)
                        .toList();
                    tourResult.clear();
                    tourPairings.sort((a, b) => a.table.compareTo(b.table));
                    return SingleChildScrollView(
                        child: Column(
                            children: tourPairings
                                .map((e) => PairingRow(
                                    pairing: e,
                                    callback: resultPairingCallback,
                                    isActiveTour:
                                        value.event.activeTour == value.tour))
                                .toList()));
                  }),
              appBar: AppBar(
                  actions: state.maybeMap(
                      orElse: () => [],
                      eventFinished: (value) => [],
                      loaded: (value) {
                        final tourPairings = value.event.eventPairings!
                            .where((e) => e.round == value.tour)
                            .toList();
                        return [
                          if (value.event.activeTour == value.event.tours)
                            IconButton(
                                onPressed: () {
                                  _eventBloc.add(EditEventEvent.finishEvent(
                                      event: value.event));
                                },
                                icon: Icon(
                                  Icons.flag,
                                  color: AppColors.cyan,
                                  size: 30,
                                ))
                          else if (value.tour == value.event.activeTour)
                            IconButton(
                                onPressed: () {
                                  if (tourResult.length ==
                                      tourPairings.length) {
                                    _eventBloc.add(
                                        EditEventEvent.saveTourResult(
                                            tour: value.event.activeTour,
                                            event: value.event,
                                            currentTourPairings: tourResult));
                                  } else {
                                    EasyLoading.showToast('Lock all tables');
                                  }
                                },
                                icon: Icon(
                                  Icons.save_outlined,
                                  color: AppColors.cyan,
                                  size: 30,
                                ))
                          else
                            const SizedBox()
                        ];
                      }),
                  backgroundColor: AppColors.lightDark,
                  title: state.maybeMap(
                    orElse: () => Text(
                      'Manage event',
                      style: AppStyles.textStyle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    eventFinished: (value) => Text(
                      'View results',
                      style: AppStyles.textStyle
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ))),
        );
      },
    );
  }
}
