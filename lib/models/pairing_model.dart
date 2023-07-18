import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/player_model.dart';

part 'pairing_model.freezed.dart';

part 'pairing_model.g.dart';

@freezed
class PairingModel with _$PairingModel {
  const factory PairingModel({
    required PlayerModel player1,
    required PlayerModel player2,
    required int table,
    required int round,
    int? player1TO,
    int? player1VP,
    int? player1PRIM,
    int? player2TO,
    int? player2VP,
    int? player2PRIM,
  }) = _PairingModel;

  factory PairingModel.fromJson(Map<String, dynamic> json) =>
      _$PairingModelFromJson(json);
}
