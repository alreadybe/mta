part of 'manage_users_bloc.dart';

@freezed
class ManageUsersEvent with _$ManageUsersEvent {
  factory ManageUsersEvent.changeStatus({
    required UserModel user,
    required List<UserType> newStatus,
  }) = _ManageUsersChangeStatusEvent;
  factory ManageUsersEvent.getData({String? name}) = _ManageUsersEventGetData;
  factory ManageUsersEvent.error({
    required String message,
  }) = _ManageUsersEventError;
}
