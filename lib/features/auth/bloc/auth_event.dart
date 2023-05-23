import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.initial() = _AuthInitial;

  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = _AuthLogin;

  const factory AuthEvent.register({
    required String email,
    required String firstname,
    String? nickname,
    required String lasname,
    required String password,
    required String repeatPassword,
  }) = _AuthRegister;

  const factory AuthEvent.logout() = _AuthEvent;
}
