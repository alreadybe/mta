import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/models/event.dart';

part 'main_bloc.freezed.dart';
part 'main_event.dart';
part 'main_state.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState.initial()) {
    on<MainEvent>((event, emit) async {
      await event.when(getData: (filter) async {
        await _getData(emit, filter);
      }, error: (message) async {
        await _onError(emit, message);
      });
    });
  }

  Future<void> _getData(
      Emitter<MainState> emit, Map<String, dynamic> filter) async {
    emit(MainState.loading());
    final CollectionReference eventCollection =
        FirebaseFirestore.instance.collection('events');
    final snapshot = await eventCollection.get();
    final data = snapshot.docs
        .map((event) => Event.fromJson(event.data() as Map<String, dynamic>))
        .toList();
    emit(MainState.loaded(data));
  }

  Future<void> _onError(Emitter<MainState> emit, String message) async {
    emit(MainState.error(message));
  }
}
