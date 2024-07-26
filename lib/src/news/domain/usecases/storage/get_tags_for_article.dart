import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class GetTagsForArticle extends UseCase<List<int>, Article> {
  final StorageRepository _repository;

  GetTagsForArticle(this._repository);

  @override
  ResultFuture<List<int>> call(Article params) async => _repository.getTagsForArticle(params);
}