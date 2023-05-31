part of 'edit_event_bloc.dart';

@freezed
class EditEventState with _$EditEventState {
  factory EditEventState.initial() = _EditEventStateInitial;
  factory EditEventState.firstTour(
      List<List<PlayerModel>>? pairings,
      List<PairingModel>? currentPairings,
      List<PlayerModel>? players) = _EventStateFirstTour;
  factory EditEventState.secondTour(
      List<List<PlayerModel>> pairings,
      List<PairingModel>? currentPairings,
      List<PlayerModel> players) = _EventStateSecondTour;
  factory EditEventState.thirdTour(
      List<List<PlayerModel>> pairings,
      List<PairingModel>? currentPairings,
      List<PlayerModel> players) = _EventStateThirdTour;
  factory EditEventState.finalResult(List<PlayerModel> players) =
      _EventStateFinalResult;
  factory EditEventState.loading() = _EditEventStateLoading;
  factory EditEventState.success() = _EditEventStateSuccess;
  factory EditEventState.error(String? message) = _EditEventStateError;
}
