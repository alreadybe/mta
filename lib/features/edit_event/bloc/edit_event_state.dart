part of 'edit_event_bloc.dart';

@freezed
class EditEventState with _$EditEventState {
  factory EditEventState.initial() = _EditEventStateInitial;
  factory EditEventState.eventStarted({required EventModel event}) =
      _EditEventStateEventStarted;
  factory EditEventState.eventFinished(
      {required EventModel event,
      required List<PlayerModel> result}) = _EditEventResult;
  factory EditEventState.loaded(
      {required EventModel event, required int tour}) = _EditEventStateLoaded;
  factory EditEventState.loading() = _EditEventStateLoading;
  factory EditEventState.success() = _EditEventStateSuccess;
  factory EditEventState.error(String? message) = _EditEventStateError;
}
