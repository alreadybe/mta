part of 'create_event_bloc.dart';

@freezed
class CreateEventState with _$CreateEventState {
  factory CreateEventState.initial() = _CreateEventStateInitial;
  factory CreateEventState.created() = _CreateEventStateCreated;
  factory CreateEventState.loading() = _CreateEventStateLoading;
  factory CreateEventState.error(String? message) = _CreateEventStateError;
}
