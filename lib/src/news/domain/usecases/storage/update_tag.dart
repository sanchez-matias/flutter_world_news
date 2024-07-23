import 'package:flutter_world_news/core/usecase/usecase.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/repositories/repositories.dart';

class UpdateTag extends UseCase<void, UpdateTagParams> {
  final StorageRepository _repository;

  UpdateTag(this._repository);

  @override
  ResultFuture<void> call(UpdateTagParams params) async =>
      _repository.updateTag(
        id: params.id,
        newName: params.newName,
      );
}

class UpdateTagParams {
  final int id;
  final String newName;

  UpdateTagParams({required this.id, required this.newName});
}
