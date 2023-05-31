import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/models/event_model.dart';
import 'package:mta_app/models/player_model.dart';
import 'package:mta_app/models/user_model.dart';

part 'event_bloc.freezed.dart';
part 'event_event.dart';
part 'event_state.dart';

@injectable
class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc() : super(EventState.loading()) {
    on<EventEvent>((event, emit) async {
      await event.mapOrNull(
          apply: (value) async => _apply(emit, value.user, value.event),
          showEvent: (value) async => _showEvent(emit, value.event),
          error: (value) async => _onError(emit, value.message, value.event));
    });
  }

  Future<void> _apply(
      Emitter<EventState> emit, UserModel user, EventModel event) async {
    emit(EventState.loading());
    final CollectionReference eventCollection =
        FirebaseFirestore.instance.collection('events');
    final eventQuery =
        await eventCollection.where('id', isEqualTo: event.id).get();

    if (event.appliedPlayers
            ?.firstWhere((element) => element.userId == user.id) !=
        null) {
      emit(EventState.error('You already applied'));
      emit(EventState.loaded(event: event));
      return;
    }

    final newApplicant = [
      ...?event.appliedPlayers,
      PlayerModel(
          id: UniqueKey().toString(),
          userId: user.id,
          firstname: user.firstname,
          nickname: user.nickname,
          lastname: user.lastname,
          to: 0,
          vp: 0,
          primary: 0,
          toOpponents: 0)
    ];
    try {
      await eventQuery.docs.first.reference.update({
        'appliedPlayers': newApplicant.map((e) => e.toJson()),
      });
    } on Exception {
      rethrow;
    }

    emit(EventState.userApplied());
    emit(
        EventState.loaded(event: event.copyWith(appliedPlayers: newApplicant)));
  }

  Future<void> _showEvent(Emitter<EventState> emit, EventModel event) async {
    emit(EventState.loaded(event: event));
  }

  Future<void> _onError(
      Emitter<EventState> emit, String message, EventModel event) async {
    emit(EventState.error(message));
    emit(EventState.loaded(event: event));
  }
}
