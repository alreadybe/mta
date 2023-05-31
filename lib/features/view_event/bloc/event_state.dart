part of 'event_bloc.dart';

@freezed
class EventState with _$EventState {
  factory EventState.loaded({required EventModel event}) = _EventStateLoaded;
  factory EventState.loading() = _EventStateLoading;
  factory EventState.userApplied() = _EventStateUserApplied;
  factory EventState.error(String? message) = _EventStateError;
}
