import 'package:freezed_annotation/freezed_annotation.dart';

part 'pairing_model.freezed.dart';

part 'pairing_model.g.dart';

@freezed
class PairingModel with _$PairingModel {
  const factory PairingModel({
    required List<String> players,
    required List<int> toRes,
    required List<int> vpRes,
  }) = _PairingModel;

  factory PairingModel.fromJson(Map<String, dynamic> json) =>
      _$PairingModelFromJson(json);
}
