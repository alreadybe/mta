part of 'edit_event_bloc.dart';

@freezed
class EditEventEvent with _$EditEventEvent {
  factory EditEventEvent.loadEvent({required EventModel event}) =
      _EditEventLoadEvent;
  factory EditEventEvent.finishEvent({required EventModel event}) =
      _EditEventFinish;
  factory EditEventEvent.startEvent(
      {required EventModel event,
      required List<PairingModel> currentTourPairings}) = _EditEventStartEvent;
  factory EditEventEvent.selectTour(
      {required int tour, required EventModel event}) = _SelectTourEvent;
  factory EditEventEvent.saveTourResult(
      {required int tour,
      required EventModel event,
      required List<PairingModel> currentTourPairings}) = _SaveTourResultEvent;
  factory EditEventEvent.error({
    required String message,
  }) = _EditEventError;
}
