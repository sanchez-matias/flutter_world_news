import 'package:flutter_world_news/core/utils/typedef.dart';

abstract class UseCase<Type, Params> {
  const UseCase();

  ResultFuture<Type> call(Params params);
}

abstract class ParamlessUseCase<Type> {
  const ParamlessUseCase();

  ResultFuture<Type> call();
}
