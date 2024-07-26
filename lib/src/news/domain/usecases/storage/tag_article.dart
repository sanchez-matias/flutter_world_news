import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class TagArticle extends UseCase<void, TagArticleParams> {
  final StorageRepository _repository;

  TagArticle(this._repository);

  @override
  ResultFuture<void> call(TagArticleParams params) async =>
      _repository.tagArticle(
        articleUrl: params.articleUrl,
        tagId: params.tagId,
      );
}

class TagArticleParams {
  final String articleUrl;
  final int tagId;

  TagArticleParams({required this.articleUrl, required this.tagId});
}
