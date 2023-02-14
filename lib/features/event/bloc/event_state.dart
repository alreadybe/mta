part of 'event_bloc.dart';

@freezed
class EventState with _$EventState {
  factory EventState.initial() = _EventStateInitial;
  factory EventState.firstTour(
          List<List<PlayerModel>>? pairings, List<PlayerModel>? players) =
      _EventStateFirstTour;
  factory EventState.secondTour(
          List<List<PlayerModel>> pairings, List<PlayerModel> players) =
      _EventStateSecondTour;
  factory EventState.thirdTour(
          List<List<PlayerModel>> pairings, List<PlayerModel> players) =
      _EventStateThirdTour;
  factory EventState.finalResult(List<PlayerModel> players) =
      _EventStateFinalResult;
  factory EventState.loading() = _EventStateLoading;
  factory EventState.success() = _EventStateSuccess;
  factory EventState.error(String? message) = _EventStateError;
}
