import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class UntagArticle extends UseCase<void, UntagArticleParams> {
  final StorageRepository _repository;

  UntagArticle(this._repository);

  @override
  ResultFuture<void> call(UntagArticleParams params) async =>
      _repository.untagArticle(
        articleUrl: params.articleUrl,
        tagId: params.tagId,
      );
}

class UntagArticleParams {
  final String articleUrl;
  final int tagId;

  UntagArticleParams({required this.articleUrl, required this.tagId});
}
