part of 'event_bloc.dart';

@freezed
class EventEvent with _$EventEvent {
  factory EventEvent.getFirstPairings(
      {required List<GlobalKey> pairingKeys,
      required String eventId}) = _GetFirstPairingsEvent;
  factory EventEvent.savePairings(
      {required Map<int, List<PlayerModel>> pairings,
      required String eventId,
      required int tour}) = _SavePairingsEvent;
  factory EventEvent.error({
    required String message,
  }) = _EventError;
}
