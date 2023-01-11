import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  bool get isAuthenticated => maybeMap(authenticated: (_) => true, orElse: () => false);

  bool get isLoading => maybeMap(loading: (_) => true, orElse: () => false);

  const AuthState._();

  const factory AuthState.initial() = _AuthInitial;

  const factory AuthState.authenticated({required User user}) = _AuthAuthenticated;

  const factory AuthState.unauthenticated() = _AuthUnauthenticated;

  const factory AuthState.loading() = _AuthLoading;

  const factory AuthState.error(String? message) = _Error;
}
