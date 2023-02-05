import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/features/event/widgets/pairing_row.dart';
import 'package:mta_app/models/player_model.dart';

part 'event_bloc.freezed.dart';
part 'event_event.dart';
part 'event_state.dart';

@injectable
class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventState.initial()) {
    on<EventEvent>((event, emit) async {
      await event.when(
          getFirstPairings: (pairingKeys, eventId) async =>
              _getFirstPairings(emit, pairingKeys, eventId),
          savePairings: (pairings, eventId, tour) async =>
              _savePairings(emit, pairings, eventId, tour),
          error: (message) async => _onError(emit, message));
    });
  }

  Future<void> _getFirstPairings(Emitter<EventState> emit,
      List<GlobalKey> pairingKeys, String eventId) async {
    final firstPairings = <int, List<PlayerModel>>{};
    for (final key in pairingKeys) {
      final newKey = key as GlobalKey<PairingRowState>;
      final player1 = PlayerModel(
          id: UniqueKey().toString(),
          name: newKey.currentState!.firstPlayerController.text,
          to: _getTO(newKey.currentState!.firstPlayerResultController.text),
          vp: int.parse(newKey.currentState!.firstPlayerResultController.text),
          primary: 0,
          toOpponents: 0);
      final player2 = PlayerModel(
          id: UniqueKey().toString(),
          name: newKey.currentState!.secondPlayerController.text,
          to: _getTO(newKey.currentState!.secondPlayerResultController.text),
          vp: int.parse(newKey.currentState!.secondPlayerResultController.text),
          primary: 0,
          toOpponents: 0);

      firstPairings.addAll({
        pairingKeys.indexOf(key): [player1, player2]
      });
    }
    await _savePairings(emit, firstPairings, eventId, 1);
  }

  Future<void> _savePairings(Emitter<EventState> emit,
      Map<int, List<PlayerModel>> pairings, String eventId, int tour) async {
    emit(EventState.loading());
    final CollectionReference eventCollection =
        FirebaseFirestore.instance.collection('events');
    final event = await eventCollection.where('id', isEqualTo: eventId).get();
    print(pairings.map((key, value) =>
        MapEntry(key.toString(), value.map((e) => e.toJson()).toList())));
    await event.docs.first.reference.update({
      '${tour}TourPairings': pairings.map((key, value) =>
          MapEntry(key.toString(), value.map((e) => e.toJson()).toList()))
    });
  }

  Future<void> _onError(Emitter<EventState> emit, String message) async {
    emit(EventState.error(message));
  }

  int _getTO(String vp) {
    final intVP = int.parse(vp);
    if (intVP > 11) {
      return 3;
    } else if (intVP > 9) {
      return 0;
    } else {
      return 1;
    }
  }
}
