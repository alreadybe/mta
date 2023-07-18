import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/event_status.dart';
import 'package:mta_app/models/event_type.dart';
import 'package:mta_app/models/pairing_model.dart';
import 'package:mta_app/models/player_model.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String orgUserId,
    required DateTime date,
    required String name,
    String? description,
    String? reglament,
    required int memberNumber,
    required EventType type,
    required int tours,
    required int activeTour,
    required int pts,
    List<PlayerModel>? appliedPlayers,
    int? elo,
    List<PairingModel>? eventPairings,
    required EventStatus status,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
