part of 'manage_users_bloc.dart';

@freezed
class ManageUsersState with _$ManageUsersState {
  factory ManageUsersState.initial() = _ManageUsersInitial;
  factory ManageUsersState.loading() = _ManageUsersLoading;
  factory ManageUsersState.loaded(List<UserModel> users) = _ManageUsersLoaded;
  factory ManageUsersState.error(String? message) = _ManageUsersError;
}
