import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/tag.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  final GetTags _getTags;
  final CreateTag _createTag;
  final UpdateTag _updateTag;
  final DeleteTag _deleteTag;

  TagsCubit({
    required GetTags getTags,
    required CreateTag createTag,
    required UpdateTag updateTag,
    required DeleteTag deleteTag,
  })  : _getTags = getTags,
        _createTag = createTag,
        _updateTag = updateTag,
        _deleteTag = deleteTag,
        super(const TagsState());

  void _resetStatus() {
    emit(state.copyWith(status: DatabaseStatus.initial));
  }

  Future<void> getTags() async {
    _resetStatus();
    final result = await _getTags();

    result.fold(
      (failure) => emit(state.copyWith(status: DatabaseStatus.failure)),
      (tags) => emit(
        state.copyWith(
          status: DatabaseStatus.success,
          tags: tags,
        ),
      ),
    );
  }

  Future<void> createTag(String name) async {
    _resetStatus();
    final result = await _createTag(name);

    result.fold(
      (failure) => emit(state.copyWith(status: DatabaseStatus.failure)),
      (success) {
        emit(state.copyWith(status: DatabaseStatus.success));
        getTags();
      }
    );
  }

  Future<void> updateTag({required int id, required String newName}) async {
    _resetStatus();
    final result = await _updateTag(UpdateTagParams(id: id, newName: newName));

    result.fold(
      (failure) => emit(state.copyWith(status: DatabaseStatus.failure)),
      (success) {
        emit(state.copyWith(status: DatabaseStatus.success));
        getTags();
      }
    );
  }

  Future<void> deleteTags(List<int> ids) async {
    _resetStatus();
    final result = await _deleteTag(ids);

    result.fold(
      (failure) => emit(state.copyWith(status: DatabaseStatus.failure)),
      (success) {
        emit(state.copyWith(status: DatabaseStatus.success));
        getTags();
      }
    );
  }
}
