import 'package:dartz/dartz.dart';
import 'package:flutter_world_news/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;

typedef ResultVoid = ResultFuture<void>;
