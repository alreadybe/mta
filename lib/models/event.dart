import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mta_app/models/event_type.dart';

part 'event.freezed.dart';

part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required DateTime date,
    required String name,
    String? description,
    required EventType type,
    required int tours,
    required int pts,
    int? elo,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
