import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';

abstract class RemoteRepository {
  const RemoteRepository();

  ResultFuture<List<Article>> getArticles({
    required String page,
    required String category,
    required String country,
  });

  ResultFuture<List<Article>> searchArticles({
    required String query,
    required String searchIn,
    required String language,
  });
}
