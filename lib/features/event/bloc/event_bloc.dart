// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
          selectTour: (tour) => _selectTour(emit, tour),
          saveTourResult: (pairingKeys, tour) async =>
              _saveTourResult(emit, pairingKeys, tour),
          error: (message) async => _onError(emit, message));
    });
  }

  static const String eventId = '[#3828e]';
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> _selectTour(Emitter<EventState> emit, int tour) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    final players = await _getPlayers(event);

    switch (tour) {
      case 1:
        final pairings = await _getCurrentTourPairings(eventId, tour);
        emit(EventState.firstTour(pairings, players));
        break;
      case 2:
        var pairings = await _getCurrentTourPairings(eventId, tour);
        pairings ??= await _nextTourPairings(eventId, tour);
        emit(EventState.secondTour(pairings, players!));
        break;
      case 3:
        var pairings = await _getCurrentTourPairings(eventId, tour);
        pairings ??= await _nextTourPairings(eventId, tour);
        emit(EventState.thirdTour(pairings, players!));
        break;
      case 4:
        emit(EventState.finalResult(_sortPlayers(players!)));
        break;
      default:
    }
  }

  Future<List<List<PlayerModel>>> _getTourResult(
      List<GlobalKey> pairingKeys, String eventId) async {
    final tourResult = <List<PlayerModel>>[];
    for (final key in pairingKeys) {
      final newKey = key as GlobalKey<PairingRowState>;

      final playerOneName = newKey.currentState!.firstPlayerController.text;
      final playerTwoName = newKey.currentState!.secondPlayerController.text;

      final playerOnePrimary = int.parse(
          newKey.currentState!.firstPlayerPrimaryResultController.text);
      final playerTwoPrimary = int.parse(
          newKey.currentState!.secondPlayerPrimaryResultController.text);

      final playerOneVP = _getVp(playerOnePrimary, playerTwoPrimary);
      final playerTwoVP = _getVp(playerTwoPrimary, playerOnePrimary);

      final playerOneTO = _getTO(playerOneVP);
      final playerTwoTO = _getTO(playerTwoVP);

      final eventQuery =
          await eventCollection.where('id', isEqualTo: eventId).get();
      final event = eventQuery.docs.first.data() as Map<String, dynamic>;
      final players = await _getPlayers(event);

      final player1 = PlayerModel(
        id: players != null
            ? players.firstWhere((element) => element.name == playerOneName).id
            : UniqueKey().toString(),
        name: playerOneName,
        to: playerOneTO,
        vp: playerOneVP,
        primary: playerOnePrimary,
        toOpponents: playerTwoTO,
      );
      final player2 = PlayerModel(
        id: players != null
            ? players.firstWhere((element) => element.name == playerTwoName).id
            : UniqueKey().toString(),
        name: playerTwoName,
        to: playerTwoTO,
        vp: playerTwoVP,
        primary: playerTwoPrimary,
        toOpponents: playerOneTO,
      );

      tourResult.add([player1, player2]);
    }

    return tourResult;
  }

  Future<List<List<PlayerModel>>?> _getCurrentTourPairings(
      String eventId, int tour) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    if (!event.containsKey('${tour}TourPairings') ||
        !event.containsKey('players')) {
      return null;
    }
    final players = await _getPlayers(event);
    final currentTour = await event['${tour}TourPairings'] as Map;

    final currentTourPairings = currentTour.values
        .map((pairing) => (pairing as List)
            .map((playerId) =>
                players!.firstWhere((player) => player.id == playerId))
            .toList())
        .toList();
    return currentTourPairings;
  }

  Future<List<PlayerModel>?> _getPlayers(Map<String, dynamic> event) async {
    final players = event['players'];

    return players != null
        ? (players as List)
            .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : null;
  }

  Future<void> _saveTourResult(
      Emitter<EventState> emit, List<GlobalKey> pairingKeys, int tour) async {
    final pairings = await _getTourResult(pairingKeys, eventId);
    // emit(EventState.loading());

    try {
      final eventQuery =
          await eventCollection.where('id', isEqualTo: eventId).get();
      final event = eventQuery.docs.first.data() as Map<String, dynamic>;
      final players = await _getPlayers(event);
      final newPlayerResults = <PlayerModel>[];
      var updatedPlayers = <PlayerModel>[];

      for (final element in pairings) {
        for (final element2 in element) {
          newPlayerResults.add(element2);
        }
      }
      if (players == null) {
        updatedPlayers = newPlayerResults;
      } else {
        for (final oldPlayer in players) {
          final newPlayer = newPlayerResults
              .firstWhere((element) => element.name == oldPlayer.name);
          updatedPlayers.add(PlayerModel(
              id: oldPlayer.id,
              name: oldPlayer.name,
              to: oldPlayer.to + newPlayer.to,
              vp: oldPlayer.vp + newPlayer.vp,
              primary: oldPlayer.primary + newPlayer.primary,
              toOpponents: oldPlayer.toOpponents + newPlayer.toOpponents));
        }
      }

      final formatPlayer = updatedPlayers.map((e) => e.toJson()).toList();
      final formatTourResult = <String, List<String>>{};

      for (final element in pairings) {
        formatTourResult.addEntries([
          MapEntry(pairings.indexOf(element).toString(),
              element.map((e) => e.id).toList())
        ]);
      }

      await eventQuery.docs.first.reference.update(
          {'players': formatPlayer, '${tour}TourPairings': formatTourResult});
    } on Exception catch (e) {
      await EasyLoading.showError(e.toString());
    }
    await EasyLoading.showSuccess('Success');
  }

  Future<void> _onError(Emitter<EventState> emit, String message) async {
    emit(EventState.error(message));
  }

  int _getTO(int vp) {
    if (vp > 11) {
      return 3;
    } else if (vp < 9) {
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

  bool _alreadyPlayed(Map<String, dynamic> event, int tour, PlayerModel player1,
      PlayerModel player2) {
    var result = false;
    if (player1 == player2) return true;
    if (tour == 1) return false;
    if (tour > 1) {
      final firstTour = event['1TourPairings'] as Map<String, dynamic>;
      for (final pairing in firstTour.values) {
        if ((pairing as List).contains(player1.id) &&
            pairing.contains(player2.id)) {
          result = true;
        }
      }
    }
    if (tour > 2) {
      final secondTour = event['2TourPairings'] as Map<String, dynamic>;
      for (final pairing in secondTour.values) {
        if ((pairing as List).contains(player1.id) &&
            pairing.contains(player2.id)) {
          result = true;
        }
      }
    }
    return result;
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

  Future<List<List<PlayerModel>>> _nextTourPairings(
      String eventId, int tour) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    final rawPlayers = await _getPlayers(event);

    final players = _sortPlayers(rawPlayers!);

    var opponentsList = [...players];

    final nextTourPairings = <List<PlayerModel>>[];
    for (var i = 0; opponentsList.length > 1; i++) {
      final player1 = players[i];
      if (opponentsList.contains(player1)) {
        final pairing = [player1];
        if (opponentsList.length > 2) {
          final player2 = opponentsList.firstWhere(
              (opponent) => !_alreadyPlayed(event, tour, player1, opponent));
          pairing.add(player2);
          opponentsList
            ..remove(player1)
            ..remove(player2);
        } else {
          if (!_alreadyPlayed(event, tour, player1, opponentsList.last)) {
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
          nextTourPairings.add(pairing);
        }
      }
    }

    return nextTourPairings;
  }
}
