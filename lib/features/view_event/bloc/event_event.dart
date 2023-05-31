part of 'event_bloc.dart';

@freezed
class EventEvent with _$EventEvent {
  factory EventEvent.showEvent({
    required EventModel event,
  }) = _ShowEvent;
  factory EventEvent.apply({
    required UserModel user,
    required EventModel event,
  }) = _ApplyUserEvent;
  factory EventEvent.error({
    required String message,
    required EventModel event,
  }) = _EventError;
}
