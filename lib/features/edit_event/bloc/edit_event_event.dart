part of 'edit_event_bloc.dart';

@freezed
class EditEventEvent with _$EditEventEvent {
  factory EditEventEvent.selectTour({required int tour}) = _SelectTourEvent;
  factory EditEventEvent.saveTourResult(
      {required List<GlobalKey> pairingKeys,
      required int tour}) = _SaveTourResultEvent;
  factory EditEventEvent.error({
    required String message,
  }) = _EditEventError;
}
