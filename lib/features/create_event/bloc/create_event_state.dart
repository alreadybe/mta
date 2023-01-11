import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_event_state.freezed.dart';

@freezed
class CreateEventState with _$CreateEventState {
  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  const CreateEventState._();

  const factory CreateEventState.initial() = _CreateEventStateInitial;

  const factory CreateEventState.created() = _CreateEventStateCreated;

  const factory CreateEventState.loading() = _CreateEventStateLoading;

  const factory CreateEventState.error(String? message) = _CreateEventStateError;
}
