import 'package:dartz/dartz.dart';
import 'package:flutter_world_news/core/errors/exceptions.dart';
import 'package:flutter_world_news/core/errors/failure.dart';
import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/data/datasources/storage_datasource.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl extends StorageRepository {
  final StorageDatasource datasource;

  StorageRepositoryImpl(this.datasource);

  @override
  ResultFuture<List<Article>> getAllArticles() async {
    try {
      return Right(await datasource.getAllArticles());
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<bool> isArticleSaved(String url) async {
    try {
      return Right(await datasource.isArticleSaved(url));
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Article>> searchArticle(String query) async {
    try {
      return Right(await datasource.searchArticle(query));
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultVoid toggleSaved(Article article) async {
    try {
      return Right(await datasource.toggleSaved(article));
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}