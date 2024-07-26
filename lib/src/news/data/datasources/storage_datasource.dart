import 'package:flutter_world_news/core/errors/exceptions.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/entities/tag.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class StorageDatasource {
  Future<List<Article>> getArticlesBy(int tagId);

  Future<List<Article>> searchArticle(String query);

  Future<void> toggleSaved(Article article);

  Future<bool> isArticleSaved(String url);

  Future<List<Tag>> getTags({Article? articleFilter});

  Future<void> createTag(String name);

  Future<void> updateTag({required int id, required String newName});

  Future<void> deleteTag(List<int> ids);

  Future<void> tagArticle({required String articleUrl, required int tagId});

  Future<void> untagArticle({required String articleUrl, required int tagId});
}

class StorageDatasourceImpl extends StorageDatasource {
  late Future<Database> _db;
  final String articlesTable = 'Articles';
  final String tagsTable = 'Tags';
  final String tagmapTable = 'Tagmap';

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

        db.execute('''
        CREATE TABLE $tagsTable (
          TagID INTEGER PRIMARY KEY AUTOINCREMENT,
          TagName TEXT,
          IsModifiable INTEGER)
        ''');

        db.rawInsert('''
        INSERT INTO $tagsTable (TagName, IsModifiable)
          VALUES ('Read Later', 0)
        ''');

        db.execute('''
        CREATE TABLE $tagmapTable (
          ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
          ArticleID INTEGER,
          TagID INTEGER,
          FOREIGN KEY (ArticleID) REFERENCES $articlesTable (ArticleID),
	        FOREIGN KEY (TagID) REFERENCES $tagsTable (TagID))
        ''');
      },
    );
    return database;
  }

  @override
  Future<List<Article>> getArticlesBy(int tagId) async {
    try {
      final database = await _db;
      late List<Map<String, dynamic>> savedArticles;

      if (tagId == 0) {
        savedArticles = await database.rawQuery('SELECT * FROM $articlesTable');
      } else {
        savedArticles = await database.rawQuery('''
        SELECT * FROM $articlesTable
        WHERE ArticleID IN (SELECT ArticleID FROM $tagmapTable
          WHERE TagID = $tagId)
        ''');
      }

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
        await database.rawDelete('''
        DELETE FROM $tagmapTable
        WHERE ArticleID = (SELECT ArticleID FROM $articlesTable
          WHERE Url = '${article.url}')
        ''');

        await database.delete(articlesTable,
            where: "Url = '${article.url}'");
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

  @override
  Future<List<Tag>> getTags({Article? articleFilter}) async {
    try {
      final database = await _db;
      late List<Map<String, dynamic>> tags;

      if (articleFilter != null) {
        tags = await database.rawQuery('''
        SELECT * FROM $tagsTable
        WHERE TagID IN (SELECT TagID FROM $tagmapTable
          WHERE ArticleID = (SELECT ArticleID FROM $articlesTable
              WHERE Url = '${articleFilter.url}'))
        ''');
      } else {
        tags = await database.rawQuery('SELECT * FROM $tagsTable');
      }
      
      return List.generate(
          tags.length,
          (index) => Tag(
                id: tags[index]['TagID'],
                name: tags[index]['TagName'],
                isModifiable: (tags[index]['IsModifiable']) == 1,
              ));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> createTag(String name) async {
    try {
      final database = await _db;
      final repeatedTags = await database
          .rawQuery("SELECT * FROM $tagsTable WHERE TagName = '$name'");

      if (repeatedTags.isNotEmpty) {
        throw const ApiException(
          messagge: 'DATABASE ERROR: TagName already registered',
          statusCode: 502,
        );
      }

      await database.rawInsert('''
      INSERT INTO $tagsTable (TagName, IsModifiable)
      VALUES ('$name', 1)
      ''');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> updateTag({required int id, required String newName}) async {
    try {
      final database = await _db;
      final repeatedTags = await database
          .rawQuery("SELECT * FROM $tagsTable WHERE TagName = '$newName'");

      if (repeatedTags.isNotEmpty) {
        throw const ApiException(
          messagge: 'DATABASE ERROR: TagName already registered',
          statusCode: 502,
        );
      }

      await database.rawUpdate('''
      UPDATE $tagsTable
      SET TagName = '$newName'
      WHERE TagID = $id AND IsModifiable = 1
      ''');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> deleteTag(List<int> ids) async {
    try {
      final database = await _db;
      final String idsToString = ids.toString()
        .replaceFirst("[", "(")
        .replaceFirst("]", ")");

      await database.rawDelete('''
      DELETE FROM $tagmapTable
      WHERE TagID IN $idsToString
      ''');
      
      await database.rawDelete('''
      DELETE FROM $tagsTable
      WHERE TagID IN $idsToString AND IsModifiable = 1
      ''');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> tagArticle({required String articleUrl, required int tagId}) async {
    try {
      final database = await _db;

      await database.rawInsert('''
      INSERT INTO $tagmapTable (ArticleID, TagID) VALUES (
      (SELECT ArticleID FROM $articlesTable WHERE Url = '$articleUrl'),
      $tagId
      )
      ''');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }

  @override
  Future<void> untagArticle({required String articleUrl, required int tagId}) async {
    try {
      final database = await _db;

      await database.rawDelete('''
      DELETE FROM $tagmapTable
      WHERE ArticleID = (SELECT ArticleID FROM $articlesTable WHERE Url = '$articleUrl')
      AND TagID = $tagId
      ''');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 501);
    }
  }
}
