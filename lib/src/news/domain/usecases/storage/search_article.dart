import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class SearchArticle extends UseCase<List<Article>, String> {
  final StorageRepository _repository;

  SearchArticle(this._repository);

  @override
  ResultFuture<List<Article>> call(String params) async =>
      _repository.searchArticle(params);
}
