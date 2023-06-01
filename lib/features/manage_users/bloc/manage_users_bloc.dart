import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mta_app/models/user_model.dart';
import 'package:mta_app/models/user_type_model.dart';

part 'managa_users_event.dart';
part 'manage_users_state.dart';
part 'manage_users_bloc.freezed.dart';

@injectable
class ManageUsersBloc extends Bloc<ManageUsersEvent, ManageUsersState> {
  ManageUsersBloc() : super(ManageUsersState.initial()) {
    on<ManageUsersEvent>((event, emit) async {
      await event.when(getData: (name) async {
        await _getData(emit, name);
      }, changeStatus: (user, newStatus) async {
        await _changeStatus(emit, user, newStatus);
      }, error: (message) async {
        await _onError(emit, message);
      });
    });
  }

  Future<void> _changeStatus(Emitter<ManageUsersState> emit, UserModel user,
      List<UserType> newStatus) async {
    emit(ManageUsersState.loading());
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final userQuery =
        await usersCollection.where('id', isEqualTo: user.id).get();

    final newUser = user.copyWith(userType: newStatus);

    try {
      await userQuery.docs.first.reference.update(newUser.toJson());
    } on Exception {
      rethrow;
    }

    add(ManageUsersEvent.getData());
  }

  Future<void> _getData(Emitter<ManageUsersState> emit, String? name) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    final snapshot = await usersCollection.get();

    final data = snapshot.docs
        .map(
            (event) => UserModel.fromJson(event.data() as Map<String, dynamic>))
        .toList();
    emit(ManageUsersState.loaded(data.where((user) {
      if (name != null && name.trim().isNotEmpty) {
        if (user.firstname.toLowerCase().contains(name.toLowerCase())) {
          return true;
        } else if (user.nickname != null &&
            user.nickname!.toLowerCase().contains(name.toLowerCase())) {
          return true;
        } else if (user.lastname.toLowerCase().contains(name.toLowerCase())) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    }).toList()));
  }

  Future<void> _onError(Emitter<ManageUsersState> emit, String message) async {
    emit(ManageUsersState.error(message));
  }
}
