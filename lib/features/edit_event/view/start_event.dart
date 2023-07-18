import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mta_app/core/theme/colors.dart';
import 'package:mta_app/core/theme/styles.dart';
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart';
import 'package:mta_app/features/edit_event/view/edit_event.dart';
import 'package:mta_app/features/edit_event/widgets/create_pairing_row.dart';
import 'package:mta_app/features/main/bloc/main_bloc.dart';
import 'package:mta_app/features/view_event/bloc/event_bloc.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

class StartEventPage extends StatefulWidget {
  const StartEventPage({super.key});

  static const routeName = 'start_event';

  @override
  State<StartEventPage> createState() => _StartEventPageState();
}

class _StartEventPageState extends State<StartEventPage> {
  late List<Map<String, PlayerModel>> _pairingsValues;
  late List<PairingModel> eventPairings;
  late EditEventBloc _editEventBloc;
  late MainBloc _mainBloc;
  late EventBloc _eventBloc;
  late int tableNum;

  @override
  void initState() {
    _pairingsValues = [];
    eventPairings = [];
    tableNum = 0;
    _eventBloc = context.read();
    _editEventBloc = context.read();
    _mainBloc = context.read();
    super.initState();
  }

  void createPairingCallback(PairingModel pairing) {
    setState(() {
      eventPairings.add(pairing);
      tableNum = 0;
    });
  }

  List<PlayerModel> _generatePlayers(int count) {
    final firstnames = [
      'Игорь',
      'Афоня',
      'Петр',
      'Вячеслав',
      'Гриша',
      'Паша',
      'Артем',
      'Лекс',
      'Миха',
      'Робуте',
      'Лемур',
      'Локи',
      'Маша',
      'Юми',
      'Азек',
      'Данила',
      'Магнус',
      'Камчатка',
      'Рина',
      'Пупсень'
    ];

    final lastnames = [
      'Зеленый',
      'Кабачковый',
      'Уринотерапиев',
      'Кашеваров',
      'Красный',
      'Охотничьев',
      'Собакаев',
      'Игремов',
      'Вупсеньский',
      'Локустов',
      'Кокоченко',
      'Блеводронов',
      'Мироедов',
      'Заказемов',
      'Ариманов',
      'Полтергейстов',
      'Ебокваков',
      'Кокоджамбов',
      'Транспортов',
      'Стрелялов'
    ];

    final result = <PlayerModel>[];
    for (var i = 0; i < count; i++) {
      result.add(PlayerModel(
          id: UniqueKey().toString(),
          userId: UniqueKey().toString(),
          firstname: firstnames[Random().nextInt(firstnames.length - 1)],
          lastname: lastnames[Random().nextInt(lastnames.length - 1)],
          to: 0,
          vp: 0,
          primary: 0,
          toOpponents: 0));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEventBloc, EditEventState>(
      listener: (context, state) {
        state.mapOrNull(eventStarted: (value) {
          _mainBloc.add(MainEvent.getData(filter: {}));
          _eventBloc.add(EventEvent.showEvent(event: value.event));
          Navigator.pushReplacementNamed(context, EditEventPage.routeName);
        });
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.dark,
          floatingActionButton: state.maybeMap(
              orElse: () => const SizedBox(),
              loaded: (value) => FloatingActionButton(
                  backgroundColor: AppColors.cyan,
                  child: const Icon(
                    Icons.skip_next,
                    size: 32,
                  ),
                  onPressed: () {
                    if (eventPairings.isEmpty) {
                      EasyLoading.showError('Pairings is empty');
                      return;
                    }
                    _editEventBloc.add(EditEventEvent.startEvent(
                        event: value.event,
                        currentTourPairings: eventPairings));
                  })),
          body: state.maybeMap(
              orElse: () => Center(
                    child: CircularProgressIndicator(color: AppColors.red),
                  ),
              loaded: (value) {
                final appliedPlayers = <PlayerModel>[
                  ...value.event.appliedPlayers ?? [],
                  ..._generatePlayers(6)
                ];
                _pairingsValues =
                    List.filled((appliedPlayers.length / 2).round(), {});
                return SingleChildScrollView(
                  child: Column(children: [
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                        ),
                        Column(
                          children: [
                            ..._pairingsValues.map((e) {
                              tableNum++;
                              return CreatePairingRow(
                                  appliedPlayers: appliedPlayers,
                                  tableNum: tableNum,
                                  callback: createPairingCallback);
                            })
                          ],
                        ),
                      ],
                    ),
                  ]),
                );
              }),
          appBar: AppBar(
            backgroundColor: AppColors.lightDark,
            title: Text(
              'Set initial pairings',
              style: AppStyles.textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
