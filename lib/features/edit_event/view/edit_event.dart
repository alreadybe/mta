import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mta_app/const/assets/assets.gen.dart';
import 'package:mta_app/features/edit_event/bloc/edit_event_bloc.dart';
import 'package:mta_app/features/edit_event/widgets/pairing_row.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key});

  static const routeName = 'edit_event';

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late EditEventBlock _eventBloc;
  late String eventId;
  late Map<GlobalKey, Widget> pairingRows;

  @override
  void initState() {
    super.initState();
    pairingRows = {};
    _eventBloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditEventBlock, EditEventState>(
      listener: (context, state) => state.mapOrNull(),
      builder: (context, state) {
        final index = state.mapOrNull(
              firstTour: (value) => 0,
              secondTour: (value) => 1,
              thirdTour: (value) => 2,
              finalResult: (value) => 3,
            ) ??
            0;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () => _eventBloc.add(EditEventEvent.saveTourResult(
                  pairingKeys: pairingRows.keys.toList(), tour: index + 1))),
          body: SingleChildScrollView(
            child: state.mapOrNull(
              firstTour: (value) => Column(
                children: [
                  if (value.pairings != null)
                    ...value.pairings!.map((e) {
                      final key = GlobalKey<PairingRowState>();
                      final currentPairing = value.currentPairings != null
                          ? value.currentPairings![value.pairings!.indexOf(e)]
                          : null;
                      final widget = PairingRow(
                          key: key, pairing: e, currentPairing: currentPairing);
                      pairingRows.addEntries({key: widget}.entries);
                      return widget;
                    }).toList()
                  else ...[
                    ...pairingRows.keys
                        .map((key) => PairingRow(key: key))
                        .toList(),
                    ElevatedButton(
                        onPressed: () {
                          final key = GlobalKey<PairingRowState>();
                          setState(() {
                            pairingRows.addEntries(
                                {key: PairingRow(key: key)}.entries);
                          });
                        },
                        child: const Text('add')),
                  ]
                ],
              ),
              secondTour: (value) => Column(
                children: [
                  ...value.pairings.map((e) {
                    final key = GlobalKey<PairingRowState>();
                    final currentPairing = value.currentPairings != null
                        ? value.currentPairings![value.pairings.indexOf(e)]
                        : null;
                    final widget = PairingRow(
                        key: key, pairing: e, currentPairing: currentPairing);
                    pairingRows.addEntries({key: widget}.entries);
                    return widget;
                  }).toList()
                ],
              ),
              thirdTour: (value) => Column(
                children: [
                  ...value.pairings.map((e) {
                    final key = GlobalKey<PairingRowState>();
                    final currentPairing = value.currentPairings != null
                        ? value.currentPairings![value.pairings.indexOf(e)]
                        : null;
                    final widget = PairingRow(
                        key: key, pairing: e, currentPairing: currentPairing);
                    pairingRows.addEntries({key: widget}.entries);
                    return widget;
                  }).toList()
                ],
              ),
              finalResult: (value) => Column(
                children: [
                  ...value.players.map((player) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Name: ${player.nickname}'),
                          Text('TO: ${player.to.toString()}'),
                          Text('VP: ${player.vp.toString()}'),
                          Text('Primary: ${player.primary.toString()}'),
                          Text('TO Opponents: ${player.toOpponents.toString()}')
                        ],
                      ))
                ],
              ),
            ),
          ),
          bottomNavigationBar: state.maybeMap(
              // loading: (value) => const SizedBox(),
              orElse: () => BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.grey[800],
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      onTap: (value) {
                        _eventBloc
                            .add(EditEventEvent.selectTour(tour: value + 1));
                        pairingRows.clear();
                      },
                      currentIndex: index,
                      items: [
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            Assets.svg.oneIcon.path,
                            colorFilter: ColorFilter.mode(
                                index == 0 ? Colors.white : Colors.grey[600]!,
                                BlendMode.color),
                          ),
                          label: 'First',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            Assets.svg.twoIcon.path,
                            colorFilter: ColorFilter.mode(
                                index == 1 ? Colors.white : Colors.grey[600]!,
                                BlendMode.color),
                          ),
                          label: 'Second',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            Assets.svg.threeIcon.path,
                            colorFilter: ColorFilter.mode(
                                index == 2 ? Colors.white : Colors.grey[600]!,
                                BlendMode.color),
                          ),
                          label: 'Third',
                        ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            Assets.svg.finalIcon.path,
                            colorFilter: ColorFilter.mode(
                                index == 3 ? Colors.white : Colors.grey[600]!,
                                BlendMode.color),
                          ),
                          label: 'Result',
                        ),
                      ])),
          appBar: AppBar(
            title: const Text('Edit event'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }
}
