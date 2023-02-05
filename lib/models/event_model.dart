import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/event_type.dart';

part 'event_model.freezed.dart';

part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required DateTime date,
    required String name,
    String? description,
    required EventType type,
    required int tours,
    required int pts,
    int? elo,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
