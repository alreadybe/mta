import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/features/create_event/bloc/create_event_event.dart';
import 'package:mta_app/features/create_event/bloc/create_event_state.dart';
import 'package:mta_app/models/event.dart';

@injectable
class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(const CreateEventState.initial()) {
    on<CreateEventEvent>((event, emit) async {
      await event.when(
        initial: () => _init(emit),
        createEvent: (event) => _createEvent(emit, event),
        error: (message) => _onError(emit, message),
      );
    });
  }

  Future<void> _init(Emitter<CreateEventState> emit) async {}

  Future<void> _createEvent(Emitter<CreateEventState> emit, Event event) async {
    emit(const CreateEventState.loading());
    final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
    await eventCollection
        .add(event.toJson())
        .then((value) => emit(const CreateEventState.created()))
        .catchError((error) => emit(CreateEventState.error(error.toString())));
  }

  Future<void> _onError(Emitter<CreateEventState> emit, String message) async {
    emit(CreateEventState.error(message));
  }
}
