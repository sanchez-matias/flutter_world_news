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
  final String articlesTable = 'Articles';

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
        CREATE TABLE $articlesTable (
	        ArticleID	INTEGER PRIMARY KEY AUTOINCREMENT,
	        Author TEXT,
	        Content	TEXT,
	        Description	TEXT,
	        PublishedAt	TEXT,
	        SourceName TEXT,
	        Title	TEXT,
	        Url	TEXT,
	        UrlToImage TEXT)
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
          await database.rawQuery('SELECT * FROM $articlesTable');

      return List.generate(
          savedArticles.length,
          (i) => Article(
                id: savedArticles[i]['ArticleID'],
                author: savedArticles[i]['Author'],
                content: savedArticles[i]['Content'],
                description: savedArticles[i]['Description'],
                publishedAt: savedArticles[i]['PublishedAt'],
                sourceName: savedArticles[i]['SourceName'],
                title: savedArticles[i]['Title'],
                url: savedArticles[i]['Url'],
                urlToImage: savedArticles[i]['UrlToImage'],
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
          await database.query(articlesTable, where: "Url = '$url'");

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
      SELECT * FROM $articlesTable
      WHERE Title COLLATE Latin1_General_CS_AS LIKE "%$query%" 
      OR Description COLLATE Latin1_General_CS_AS LIKE "%$query%"
      ''');

      return List.generate(
        result.length,
        (i) => Article(
          id: result[i]['ArticleID'],
          author: result[i]['Author'],
          content: result[i]['Content'],
          description: result[i]['Description'],
          publishedAt: result[i]['PublishedAt'],
          sourceName: result[i]['SourceName'],
          title: result[i]['Title'],
          url: result[i]['Url'],
          urlToImage: result[i]['UrlToImage'],
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
        await database.delete(articlesTable,
            where: "ArticleID = '${article.id}'");
        return;
      }

      await database.insert(articlesTable, {
        'Author': article.author,
        'Content': article.content,
        'Description': article.description,
        'PublishedAt': article.publishedAt,
        'SourceName': article.sourceName,
        'Title': article.title,
        'Url': article.url,
        'UrlToImage': article.urlToImage,
      });
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }
}
