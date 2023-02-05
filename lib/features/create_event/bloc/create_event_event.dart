part of 'create_event_bloc.dart';

@freezed
class CreateEventEvent with _$CreateEventEvent {
  factory CreateEventEvent.createEvent({
    required EventModel event,
  }) = _CreateEvent;
  factory CreateEventEvent.error({
    required String message,
  }) = _CreateEventError;
}
