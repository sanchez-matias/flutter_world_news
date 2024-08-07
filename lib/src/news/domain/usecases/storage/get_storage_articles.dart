import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class GetStorageArticles extends UseCase<List<Article>, int> {
  final StorageRepository _repository;

  GetStorageArticles(this._repository);

  @override
  ResultFuture<List<Article>> call(int params) async => _repository.getArticlesBy(params);
}
