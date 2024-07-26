import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/entities/tag.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  final GetTags _getTags;
  final CreateTag _createTag;
  final UpdateTag _updateTag;
  final DeleteTag _deleteTag;
  final TagArticle _tagArticle;
  final UntagArticle _untagArticle;
  final GetTagsForArticle _getTagsForArticle;

  TagsCubit(
      {required GetTags getTags,
      required CreateTag createTag,
      required UpdateTag updateTag,
      required DeleteTag deleteTag,
      required TagArticle tagArticle,
      required UntagArticle untagArticle,
      required GetTagsForArticle getTagsForArticle})
      : _getTags = getTags,
        _createTag = createTag,
        _updateTag = updateTag,
        _deleteTag = deleteTag,
        _tagArticle = tagArticle,
        _untagArticle = untagArticle,
        _getTagsForArticle = getTagsForArticle,
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
      },
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
      },
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
      },
    );
  }

  Future<bool> tagArticle({
    required String articleUrl,
    required int tagId,
  }) async {
    final result = await _tagArticle(TagArticleParams(
      articleUrl: articleUrl,
      tagId: tagId,
    ));

    return result.fold(
      (failure) => false,
      (success) => true,
    );
  }

  Future<bool> untagArticle({
    required String articleUrl,
    required int tagId,
  }) async {
    final result = await _untagArticle(UntagArticleParams(
      articleUrl: articleUrl,
      tagId: tagId,
    ));

    return result.fold(
      (failure) => false,
      (success) => true,
    );
  }

  Future<List<int>?> getTagsForArticle(Article article) async {
    final result = await _getTagsForArticle(article);

    return result.fold(
      (failure) => null,
      (success) => success,
    );
  }
}
