part of 'tags_cubit.dart';

enum DatabaseStatus { initial, failure, success }

class TagsState extends Equatable {
  final List<Tag> tags;
  final DatabaseStatus status;
  final int selectedTagId;

  const TagsState({
    this.tags = const [],
    this.status = DatabaseStatus.initial,
    this.selectedTagId = 0,
  });

  TagsState copyWith({
    List<Tag>? tags,
    DatabaseStatus? status,
    int? selectedTagId,
  }) =>
      TagsState(
        tags: tags ?? this.tags,
        status: status ?? this.status,
        selectedTagId: selectedTagId ?? this.selectedTagId,
      );

  @override
  List<Object> get props => [tags, status, selectedTagId];
}
