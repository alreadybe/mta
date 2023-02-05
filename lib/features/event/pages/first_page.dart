import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mta_app/features/event/bloc/event_bloc.dart';
import 'package:mta_app/features/event/widgets/pairing_row.dart';

class FirstPage extends StatefulWidget {
  final String eventId;
  const FirstPage({required this.eventId, super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Map<GlobalKey, Widget> pairingRows = {};
  late EventBloc _eventBloc;

  @override
  void initState() {
    _eventBloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        return Column(
          children: [
            ...pairingRows.values,
            ElevatedButton(
                onPressed: () {
                  final key = GlobalKey<PairingRowState>();
                  setState(() {
                    pairingRows.addEntries({key: PairingRow(key: key)}.entries);
                  });
                },
                child: const Text('add')),
            ElevatedButton(
                onPressed: () => _eventBloc.add(EventEvent.getFirstPairings(
                    pairingKeys: pairingRows.keys.map((e) => e).toList(),
                    eventId: widget.eventId)),
                child: const Text('get data'))
          ],
        );
      },
    );
  }
}
