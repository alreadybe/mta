import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/core/locator/modules/storage.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = Storage();

  AuthBloc() : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
          initial: () => _init(emit),
          login: (email, password) => _login(emit, email, password),
          register: (email, firstname, nickname, lastname, elo, password) =>
              _register(emit, email, firstname, nickname, lastname, elo, password),
          logout: () => _logout(emit));
    });
  }

  Future<void> _init(Emitter<AuthState> emit) async {
    final user = await _storage.getUser();
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(user: user));
    }
  }

  Future<void> _login(Emitter<AuthState> emit, String email, String password) async {}

  Future<void> _register(Emitter<AuthState> emit, String email, String firstname, String? nickname,
      String lastname, double elo, String password) async {}

  Future<void> _logout(Emitter<AuthState> emit) async {}
}
