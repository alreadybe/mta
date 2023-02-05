import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';

part 'player_model.g.dart';

@freezed
class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required String id,
    required String name,
    required int to,
    required int vp,
    required int primary,
    required int toOpponents,
  }) = _PlayerModel;

  factory PlayerModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerModelFromJson(json);
}
