part of 'main_bloc.dart';

@freezed
class MainState with _$MainState {
  factory MainState.initial() = _MainStateInitial;
  factory MainState.loading() = _MainStateLoading;
  factory MainState.loaded(List<EventModel> events) = _MainStateLoaded;
  factory MainState.error(String? message) = _MainStateError;
}
