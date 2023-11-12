import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_dto.g.dart';

@JsonSerializable()
class TodoDto extends Equatable {
  @JsonKey(name: "userId")
  final int userId;
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "completed")
  final bool completed;

  const TodoDto({required this.userId, required this.id, required this.title, required this.completed});

  factory TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoDtoToJson(this);

  @override
  List<Object?> get props => [
    userId,
    id,
    title,
    completed,
  ];
}
