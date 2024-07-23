import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/tag.dart';
import 'package:flutter_world_news/src/news/domain/repositories/repositories.dart';

class GetTags extends ParamlessUseCase<List<Tag>> {
  final StorageRepository _repository;

  GetTags(this._repository);
  
  @override
  ResultFuture<List<Tag>> call() async => _repository.getTags();

}
