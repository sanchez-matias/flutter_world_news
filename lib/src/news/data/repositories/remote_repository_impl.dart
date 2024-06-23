import 'package:dartz/dartz.dart';
import 'package:flutter_world_news/core/errors/exceptions.dart';
import 'package:flutter_world_news/core/errors/failure.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/data/datasources/remote_datasource.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/remote_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteDatasource _remoteDatasource;

  const RemoteRepositoryImpl(this._remoteDatasource);

  @override
  ResultFuture<List<Article>> getArticles({
    required String page,
    required String category,
    required String country,
  }) async {
    try {
      return Right(await _remoteDatasource.getArticles(
        page: page,
        category: category,
        country: country,
      ));
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Article>> searchArticles({
    required String query,
    required String searchIn,
    required String language,
  }) async {
    try {
      final result = await _remoteDatasource.searchArticles(
        query: query,
        searchIn: searchIn,
        language: language,
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}