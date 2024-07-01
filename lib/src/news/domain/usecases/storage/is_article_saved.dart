import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class IsArticleSaved extends UseCase<bool, String> {
  final StorageRepository _repository;

  IsArticleSaved(this._repository);

  @override
  ResultFuture<bool> call(String params) async =>
      _repository.isArticleSaved(params);
}
