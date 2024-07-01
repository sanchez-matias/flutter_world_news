import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';

abstract class StorageRepository {
  ResultFuture<List<Article>> getAllArticles();

  ResultFuture<List<Article>> searchArticle(String query);

  ResultVoid toggleSaved(Article article);

  ResultFuture<bool> isArticleSaved(String url);
}