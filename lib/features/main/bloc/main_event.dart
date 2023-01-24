part of 'main_bloc.dart';

@freezed
class MainEvent with _$MainEvent {
  factory MainEvent.getData({required Map<String, dynamic> filter}) =
      _MainEventGetData;
  factory MainEvent.error({
    required String message,
  }) = _MainEventError;
}
