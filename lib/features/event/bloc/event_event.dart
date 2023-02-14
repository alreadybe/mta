part of 'event_bloc.dart';

@freezed
class EventEvent with _$EventEvent {
  factory EventEvent.selectTour({required int tour}) = _SelectTourEvent;
  factory EventEvent.saveTourResult(
      {required List<GlobalKey> pairingKeys,
      required int tour}) = _SaveTourResultEvent;
  factory EventEvent.error({
    required String message,
  }) = _EventError;
}
