import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/user_type_model.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String firstname,
    required String email,
    String? nickname,
    required String lastname,
    required double elo,
    required List<UserType> userType,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
