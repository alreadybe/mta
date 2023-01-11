import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/event.dart';

part 'create_event_event.freezed.dart';

@freezed
class CreateEventEvent with _$CreateEventEvent {
  const factory CreateEventEvent.createEvent({
    required Event event,
  }) = _CreateEvent;

  const factory CreateEventEvent.error({
    required String message,
  }) = _CreateEventError;
}
