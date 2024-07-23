import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/repositories.dart';

class DeleteTag extends UseCase<void, List<int>> {
  final StorageRepository _repository;

  DeleteTag(this._repository);

  @override
  ResultFuture<void> call(List<int> params) async => _repository.deleteTag(params);
}
