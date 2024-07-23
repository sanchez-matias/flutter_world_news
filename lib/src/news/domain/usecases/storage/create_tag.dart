import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/repositories.dart';

class CreateTag extends UseCase<void, String> {
  final StorageRepository _repository;

  CreateTag(this._repository);

  @override
  ResultFuture<void> call(String params) async => _repository.createTag(params);
}
