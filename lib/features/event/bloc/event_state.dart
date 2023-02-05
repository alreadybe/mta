part of 'event_bloc.dart';

@freezed
class EventState with _$EventState {
  factory EventState.initial() = _EventStateInitial;
  factory EventState.locked() = _EventStateLocked;
  factory EventState.unlocked() = _EventStateUnlocked;
  factory EventState.loading() = _EventStateLoading;
  factory EventState.error(String? message) = _EventStateError;
}
