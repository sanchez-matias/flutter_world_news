import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class ToggleSaved extends UseCase<void, Article> {
  final StorageRepository _repository;

  ToggleSaved(this._repository);

  @override
  ResultFuture<void> call(Article params) async =>
      _repository.toggleSaved(params);
}
