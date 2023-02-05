import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/models/event_model.dart';

part 'create_event_bloc.freezed.dart';
part 'create_event_event.dart';
part 'create_event_state.dart';

@injectable
class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(CreateEventState.initial()) {
    on<CreateEventEvent>((event, emit) async {
      await event.when(createEvent: (event) async {
        await _createEvent(emit, event);
      }, error: (message) async {
        await _onError(emit, message);
      });
    });
  }

  Future<void> _createEvent(
      Emitter<CreateEventState> emit, EventModel event) async {
    emit(CreateEventState.loading());
    final CollectionReference eventCollection =
        FirebaseFirestore.instance.collection('events');
    await eventCollection
        .add(event.toJson())
        .then((value) => emit(CreateEventState.created()))
        .catchError((error) => emit(CreateEventState.error(error.toString())));
  }

  Future<void> _onError(Emitter<CreateEventState> emit, String message) async {
    emit(CreateEventState.error(message));
  }
}
