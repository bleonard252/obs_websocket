import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'studio_mode_state_changed.g.dart';

@JsonSerializable()
class StudioModeStateChanged {
  final bool studioModeEnabled;

  StudioModeStateChanged({required this.studioModeEnabled});

  factory StudioModeStateChanged.fromJson(Map<String, dynamic> json) =>
      _$StudioModeStateChangedFromJson(json);

  Map<String, dynamic> toJson() => _$StudioModeStateChangedToJson(this);

  @override
  String toString() => json.encode(toJson());
}
