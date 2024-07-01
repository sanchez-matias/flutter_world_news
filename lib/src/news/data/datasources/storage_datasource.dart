import 'package:flutter_world_news/core/errors/exceptions.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class StorageDatasource {
  Future<List<Article>> getAllArticles();

  Future<List<Article>> searchArticle(String query);

  Future<void> toggleSaved(Article article);

  Future<bool> isArticleSaved(String url);
}

class StorageDatasourceImpl extends StorageDatasource {
  late Future<Database> _db;
  final String tableName = 'Articles';

  StorageDatasourceImpl() {
    _db = openDbInstance();
  }

  Future<Database> openDbInstance() async {
    final dbDirPath = await getDatabasesPath();
    final databasePath = join(dbDirPath, 'main_storage.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $tableName (
	        ArticleID	INTEGER PRIMARY KEY AUTOINCREMENT,
	        author TEXT,
	        content	TEXT,
	        description	TEXT,
	        publishedAt	TEXT,
	        sourceName TEXT,
	        title	TEXT,
	        url	TEXT,
	        urlToImage TEXT)
        ''');
      },
    );
    return database;
  }

  @override
  Future<List<Article>> getAllArticles() async {
    try {
      final database = await _db;
      final List<Map<String, dynamic>> savedArticles =
          await database.rawQuery('SELECT * FROM $tableName');

      return List.generate(
          savedArticles.length,
          (i) => Article(
                author: savedArticles[i]['author'],
                content: savedArticles[i]['content'],
                description: savedArticles[i]['description'],
                publishedAt: savedArticles[i]['publishedAt'],
                sourceName: savedArticles[i]['sourceName'],
                title: savedArticles[i]['title'],
                url: savedArticles[i]['url'],
                urlToImage: savedArticles[i]['urlToImage'],
              ));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<bool> isArticleSaved(String url) async {
    try {
      final database = await _db;
      final queryArticles =
          await database.query(tableName, where: "url = '$url'");

      return queryArticles.isNotEmpty;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<List<Article>> searchArticle(String query) async {
    try {
      final database = await _db;
      final List<Map<String, dynamic>> result = await database.rawQuery('''
      SELECT * FROM $tableName
      WHERE title LIKE "%$query%" OR description LIKE "%$query%"
      ''');

      return List.generate(
        result.length,
        (i) => Article(
          author: result[i]['author'],
          content: result[i]['content'],
          description: result[i]['description'],
          publishedAt: result[i]['publishedAt'],
          sourceName: result[i]['sourceName'],
          title: result[i]['title'],
          url: result[i]['url'],
          urlToImage: result[i]['urlToImage'],
        ),
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> toggleSaved(Article article) async {
    try {
      final database = await _db;
      final isSaved = await isArticleSaved(article.url!);

      if (isSaved) {
        await database.delete(tableName, where: "Url = '${article.url}'");
        return;
      }

      await database.insert(tableName, {
        'author': article.author,
        'content': article.content,
        'description': article.description,
        'publishedAt': article.publishedAt,
        'sourceName': article.sourceName,
        'title': article.title,
        'url': article.url,
        'urlToImage': article.urlToImage,
      });
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }
}
