import 'package:flutter_world_news/core/utils/typedef.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/entities/tag.dart';

abstract class StorageRepository {
  ResultFuture<List<Article>> getArticlesBy(int tagId);

  ResultFuture<List<Article>> searchArticle(String query);

  ResultVoid toggleSaved(Article article);

  ResultFuture<bool> isArticleSaved(String url);

  ResultFuture<List<Tag>> getTags();
  
  ResultVoid createTag(String name);
  
  ResultVoid updateTag({required int id, required String newName});
  
  ResultVoid deleteTag(List<int> ids);

  ResultVoid tagArticle({required String articleUrl, required int tagId});

  ResultVoid untagArticle({required String articleUrl, required int tagId});

  ResultFuture<List<int>> getTagsForArticle(Article article);
}