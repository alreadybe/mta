// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/models/event_model.dart';
import 'package:mta_app/models/event_status.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

part 'edit_event_bloc.freezed.dart';
part 'edit_event_event.dart';
part 'edit_event_state.dart';

@injectable
class EditEventBloc extends Bloc<EditEventEvent, EditEventState> {
  EditEventBloc() : super(EditEventState.initial()) {
    on<EditEventEvent>((event, emit) async {
      await event.when(
          finishEvent: (event) => _finishEvent(emit, event),
          startEvent: (event, currentTourPairings) =>
              _startEvent(emit, event, currentTourPairings),
          selectTour: (tour, event) => _selectTour(emit, tour, event),
          loadEvent: (event) => _loadEvent(emit, event),
          error: (message) => _onError(emit, message),
          saveTourResult: (tour, event, currentTourPairings) =>
              _saveTourResult(emit, tour, event, currentTourPairings));
    });
  }

  Future<void> _finishEvent(
      Emitter<EditEventState> emit, EventModel event) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: event.id).get();
    final eventModel = EventModel.fromJson(
        eventQuery.docs.first.data() as Map<String, dynamic>);

    final players = _getPlayers(eventModel.eventPairings!);
    await eventQuery.docs.first.reference.update(
        {'activeTour': event.tours + 1, 'status': EventStatus.FINISHED.name});

    emit(EditEventState.eventFinished(
        event: event, result: _sortPlayers(players)));
  }

  Future<void> _startEvent(Emitter<EditEventState> emit, EventModel event,
      List<PairingModel> currentTourPairings) async {
    try {
      final eventQuery =
          await eventCollection.where('id', isEqualTo: event.id).get();

      await eventQuery.docs.first.reference.update({
        'eventPairings': currentTourPairings.map((e) => e.toJson()).toList(),
        'activeTour': 1,
        'status': EventStatus.INPROGRESS.name
      });
    } on Exception catch (e) {
      await EasyLoading.showError(e.toString());
    }

    final eventQuery =
        await eventCollection.where('id', isEqualTo: event.id).get();
    final eventModel = EventModel.fromJson(
        eventQuery.docs.first.data() as Map<String, dynamic>);
    emit(EditEventState.eventStarted(event: eventModel));
    emit(EditEventState.loaded(event: eventModel, tour: 1));
  }

  Future<void> _loadEvent(
      Emitter<EditEventState> emit, EventModel event) async {
    emit(EditEventState.loaded(
        event: event,
        tour: event.status == EventStatus.FINISHED
            ? event.tours + 1
            : event.activeTour));
  }

  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> _selectTour(
      Emitter<EditEventState> emit, int tour, EventModel event) async {
    emit(EditEventState.loading());
    final eventQuery =
        await eventCollection.where('id', isEqualTo: event.id).get();
    final eventModel = EventModel.fromJson(
        eventQuery.docs.first.data() as Map<String, dynamic>);

    final players = _getPlayers(eventModel.eventPairings!);

    if (tour > event.tours) {
      emit(EditEventState.eventFinished(
          event: event, result: _sortPlayers(players)));
    } else {
      emit(EditEventState.loaded(event: eventModel, tour: tour));
    }
  }

  Future<void> _saveTourResult(Emitter<EditEventState> emit, int tour,
      EventModel event, List<PairingModel> currentTourPairings) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: event.id).get();

    final updatedEvent = EventModel.fromJson(
        eventQuery.docs.first.data() as Map<String, dynamic>);

    final tourResult = currentTourPairings.map((e) {
      final player1VP = _getVp(e.player1PRIM!, e.player2PRIM!);
      final player2VP = _getVp(e.player2PRIM!, e.player1PRIM!);

      return e.copyWith(
        player1: e.player1.copyWith(
            primary: e.player1.primary + e.player1PRIM!,
            vp: e.player1.vp + player1VP,
            to: e.player1.to + _getTO(player1VP)),
        player2: e.player2.copyWith(
            primary: e.player2.primary + e.player2PRIM!,
            vp: e.player2.vp + player2VP,
            to: e.player2.to + _getTO(player2VP)),
        player1VP: player1VP,
        player2VP: player2VP,
        player1TO: _getTO(player1VP),
        player2TO: _getTO(player2VP),
      );
    }).toList();

    final players = _getPlayers(tourResult);

    final nextTour = await _nextTourPairings(tourResult, tour);

    final previousRounds = <PairingModel>[];

    for (var i = 1; i < tour; i++) {
      previousRounds.addAll(
          updatedEvent.eventPairings!.where((element) => element.round == i));
    }
    try {
      await eventQuery.docs.first.reference.update({
        'eventPairings': [...previousRounds, ...tourResult, ...nextTour]
            .map((e) => e.toJson())
            .toList(),
        'appliedPlayers': players.map((e) => e.toJson()).toList(),
        'activeTour': tour + 1
      });
    } on Exception catch (e) {
      await EasyLoading.showError(e.toString());
    }

    await _selectTour(emit, tour + 1, event);
  }

  Future<void> _onError(Emitter<EditEventState> emit, String message) async {
    emit(EditEventState.error(message));
  }

  int _getTO(int vp) {
    if (vp > 10) {
      return 3;
    } else if (vp < 10) {
      return 0;
    } else {
      return 1;
    }
  }

  int _getVp(int playerPrimary, int opponentPrimary) {
    final pairing = [playerPrimary, opponentPrimary]
      ..sort((a, b) => -a.compareTo(b));
    final primaryDifference = pairing.first - pairing.last;

    var winnerVP = 0;
    if (primaryDifference > 50) winnerVP = 20;
    if (primaryDifference > 45 && primaryDifference < 51) winnerVP = 19;
    if (primaryDifference > 40 && primaryDifference < 46) winnerVP = 18;
    if (primaryDifference > 35 && primaryDifference < 41) winnerVP = 17;
    if (primaryDifference > 30 && primaryDifference < 36) winnerVP = 16;
    if (primaryDifference > 25 && primaryDifference < 31) winnerVP = 15;
    if (primaryDifference > 20 && primaryDifference < 26) winnerVP = 14;
    if (primaryDifference > 15 && primaryDifference < 21) winnerVP = 13;
    if (primaryDifference > 10 && primaryDifference < 16) winnerVP = 12;
    if (primaryDifference > 5 && primaryDifference < 11) winnerVP = 11;
    if (primaryDifference >= 0 && primaryDifference < 6) winnerVP = 10;

    if (playerPrimary == pairing.first) {
      return winnerVP;
    } else {
      return 20 - winnerVP;
    }
  }

  bool _alreadyPlayed(List<PairingModel> eventPairings, PlayerModel player1,
      PlayerModel player2) {
    if (player1.id == player2.id) return true;

    return eventPairings
        .where((pairing) =>
            (pairing.player1.id == player1.id ||
                pairing.player1.id == player2.id) &&
            (pairing.player2.id == player1.id ||
                pairing.player2.id == player2.id))
        .toList()
        .isNotEmpty;
  }

  List<PlayerModel> _sortPlayers(List<PlayerModel> players) {
    players.sort((player1, player2) {
      final toCompare = -player1.to.compareTo(player2.to);
      if (toCompare == 0) {
        final vpCompare = -player1.vp.compareTo(player2.vp);
        if (vpCompare == 0) {
          final toOpponentsCompare =
              -player1.toOpponents.compareTo(player2.toOpponents);
          if (toOpponentsCompare == 0) {
            return -player1.primary.compareTo(player2.primary);
          }
          return toOpponentsCompare;
        }
        return vpCompare;
      }
      return toCompare;
    });

    return players;
  }

  List<PlayerModel> _getPlayers(List<PairingModel> pairings) {
    final seen = <String>{};
    final rawPlayers1 = pairings.map((e) => e.player1);
    final rawPlayers2 = pairings.map((e) => e.player2);
    return [...rawPlayers1, ...rawPlayers2]
        .where((element) => seen.add(element.id))
        .toList();
  }

  Future<List<PairingModel>> _nextTourPairings(
      List<PairingModel> eventPairings, int tour) async {
    final rawPlayers = _getPlayers(eventPairings);
    final players = _sortPlayers(rawPlayers);

    var opponentsList = [...players];

    final nextTourPairings = <PairingModel>[];
    for (var i = 0; opponentsList.length > 1; i++) {
      final player1 = players[i];
      if (opponentsList.contains(player1)) {
        final pairing = [player1];
        if (opponentsList.length > 2) {
          final player2 = opponentsList.firstWhere(
              (opponent) => !_alreadyPlayed(eventPairings, player1, opponent));
          pairing.add(player2);
          opponentsList
            ..remove(player1)
            ..remove(player2);
        } else {
          if (!_alreadyPlayed(eventPairings, player1, opponentsList.last)) {
            pairing.add(opponentsList.last);
            opponentsList.clear();
          } else {
            opponentsList = [
              ...players.getRange(0, players.length - 4),
              players[players.length - 4],
              players[players.length - 2],
              players[players.length - 3],
              players.last
            ];
            pairing.clear();
            nextTourPairings.clear();
            i = -1;
          }
        }
        if (pairing.isNotEmpty) {
          nextTourPairings.add(PairingModel(
              player1: pairing.first,
              player2: pairing.last,
              player1PRIM: 0,
              player2PRIM: 0,
              player1TO: 0,
              player1VP: 0,
              player2TO: 0,
              player2VP: 0,
              table: nextTourPairings.length + 1,
              round: tour + 1));
        }
      }
    }
    return nextTourPairings;
  }
}
