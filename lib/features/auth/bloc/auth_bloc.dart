// ignore_for_file: inference_failure_on_instance_creation

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/core/locator/modules/storage.dart';
import 'package:mta_app/features/auth/bloc/auth_event.dart';
import 'package:mta_app/features/auth/bloc/auth_state.dart';
import 'package:mta_app/models/user_model.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _storage = Storage();

  AuthBloc() : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.when(
          initial: () async => _init(emit),
          login: (email, password) async => _login(emit, email, password),
          register: (email, firstname, nickname, lastname, elo,
                  password) async =>
              _register(
                  emit, email, firstname, nickname, lastname, elo, password),
          logout: () async => _logout(emit));
    });
  }

  Future<void> _init(Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await Future.delayed(const Duration(seconds: 1));
    final user = await _storage.getUser();
    if (user == null) {
      emit(const AuthState.unauthenticated());
    } else {
      emit(AuthState.authenticated(user: user));
    }
  }

  Future<void> _login(
      Emitter<AuthState> emit, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        emit(const AuthState.error('No user found for that email.'));
        emit(const AuthState.unauthenticated());
        return;
      } else if (e.code == 'wrong-password') {
        emit(const AuthState.error('Wrong password provided for that user.'));
        emit(const AuthState.unauthenticated());
        return;
      }
    }
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    final snapshot = await userCollection.get();
    final user = snapshot.docs
        .map(
            (event) => UserModel.fromJson(event.data() as Map<String, dynamic>))
        .toList()
        .firstWhere((element) => element.email == email);
    await _storage.setUser(user);
    emit(AuthState.authenticated(user: user));
  }

  Future<void> _register(
      Emitter<AuthState> emit,
      String email,
      String firstname,
      String? nickname,
      String lastname,
      double elo,
      String password) async {}

  Future<void> _logout(Emitter<AuthState> emit) async {}
}
