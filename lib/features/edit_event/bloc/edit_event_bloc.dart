// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/features/edit_event/widgets/pairing_row.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

part 'edit_event_bloc.freezed.dart';
part 'edit_event_event.dart';
part 'edit_event_state.dart';

@injectable
class EditEventBlock extends Bloc<EditEventEvent, EditEventState> {
  EditEventBlock() : super(EditEventState.initial()) {
    on<EditEventEvent>((event, emit) async {
      await event.when(
          selectTour: (tour) => _selectTour(emit, tour),
          saveTourResult: (pairingKeys, tour) async =>
              _saveTourResult(emit, pairingKeys, tour),
          error: (message) async => _onError(emit, message));
    });
  }

  static const String eventId = '[#1f567]';
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> _selectTour(Emitter<EditEventState> emit, int tour) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    final players = await _getPlayers(event);

    final currentPairings = await _getCurrentTourPairings(eventId, tour);
    var pairings = await _pairingsToModel(currentPairings, eventId);

    if (tour > 1) {
      pairings ??= await _nextTourPairings(eventId, tour);
    }

    switch (tour) {
      case 1:
        emit(EditEventState.firstTour(pairings, currentPairings, players));
        break;
      case 2:
        emit(EditEventState.secondTour(pairings!, currentPairings, players!));
        break;
      case 3:
        emit(EditEventState.thirdTour(pairings!, currentPairings, players!));
        break;
      case 4:
        emit(EditEventState.finalResult(_sortPlayers(players!)));
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
              ? players
                  .firstWhere((element) => element.nickname == playerOneName)
                  .id
              : UniqueKey().toString(),
          nickname: playerOneName,
          to: playerOneTO,
          vp: playerOneVP,
          primary: playerOnePrimary,
          toOpponents: playerTwoTO,
          firstname: '',
          lastname: '',
          userId: '');
      final player2 = PlayerModel(
          id: players != null
              ? players
                  .firstWhere((element) => element.nickname == playerTwoName)
                  .id
              : UniqueKey().toString(),
          nickname: playerTwoName,
          to: playerTwoTO,
          vp: playerTwoVP,
          primary: playerTwoPrimary,
          toOpponents: playerOneTO,
          firstname: '',
          lastname: '',
          userId: '');

      tourResult.add([player1, player2]);
    }

    return tourResult;
  }

  Future<List<List<PlayerModel>>?> _pairingsToModel(
      List<PairingModel>? currentTour, String eventId) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    final players = await _getPlayers(event);
    if (currentTour == null) {
      return null;
    }
    final currentTourPairings = currentTour
        .map((pairing) => pairing.players
            .map((playerId) =>
                players!.firstWhere((player) => player.id == playerId))
            .toList())
        .toList();

    return currentTourPairings;
  }

  Future<List<PairingModel>?> _getCurrentTourPairings(
      String eventId, int tour) async {
    final eventQuery =
        await eventCollection.where('id', isEqualTo: eventId).get();
    final event = eventQuery.docs.first.data() as Map<String, dynamic>;
    if (!event.containsKey('tour$tour') || !event.containsKey('players')) {
      return null;
    }

    final currentTour = (event['tour$tour'] as List)
        .map((e) => PairingModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return currentTour;
  }

  Future<List<PlayerModel>?> _getPlayers(Map<String, dynamic> event) async {
    final players = event['players'];

    return players != null
        ? (players as List)
            .map((e) => PlayerModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : null;
  }

  Future<void> _saveTourResult(Emitter<EditEventState> emit,
      List<GlobalKey> pairingKeys, int tour) async {
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
              .firstWhere((element) => element.nickname == oldPlayer.nickname);
          updatedPlayers.add(PlayerModel(
              id: oldPlayer.id,
              nickname: oldPlayer.nickname,
              to: oldPlayer.to + newPlayer.to,
              vp: oldPlayer.vp + newPlayer.vp,
              primary: oldPlayer.primary + newPlayer.primary,
              toOpponents: oldPlayer.toOpponents + newPlayer.toOpponents,
              firstname: '',
              lastname: '',
              userId: ''));
        }
      }

      final formatPlayer = updatedPlayers.map((e) => e.toJson()).toList();
      final formatTourResult = <PairingModel>[];

      for (final pairing in pairings) {
        formatTourResult.add(PairingModel(
            players: [pairing.first.id, pairing.last.id],
            toRes: [pairing.first.to, pairing.last.to],
            vpRes: [pairing.first.vp, pairing.last.vp]));
      }

      await eventQuery.docs.first.reference.update({
        'players': formatPlayer,
        'tour$tour': formatTourResult.map((e) => e.toJson()).toList()
      });
    } on Exception catch (e) {
      await EasyLoading.showError(e.toString());
    }
    await EasyLoading.showSuccess('Success');
  }

  Future<void> _onError(Emitter<EditEventState> emit, String message) async {
    emit(EditEventState.error(message));
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
      final firstTour = (event['tour1'] as List)
          .map((e) => PairingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final pairing in firstTour) {
        if (pairing.players.contains(player1.id) &&
            pairing.players.contains(player2.id)) {
          result = true;
        }
      }
    }
    if (tour > 2) {
      final secondTour = (event['tour2'] as List)
          .map((e) => PairingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final pairing in secondTour) {
        if (pairing.players.contains(player1.id) &&
            pairing.players.contains(player2.id)) {
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
    if (rawPlayers == null) return [];
    final players = _sortPlayers(rawPlayers);

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
