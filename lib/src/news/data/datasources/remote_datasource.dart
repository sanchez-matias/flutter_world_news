import 'dart:convert';

import 'package:flutter_world_news/core/constants/environment.dart';
import 'package:flutter_world_news/core/constants/urls.dart';
import 'package:flutter_world_news/core/errors/exceptions.dart';
import 'package:flutter_world_news/src/news/data/models/article_model.dart';

import 'package:http/http.dart' as http;

abstract class RemoteDatasource {
  Future<List<ArticleModel>> getArticles({
    required String page,
    required String category,
    required String country,
  });

  Future<List<ArticleModel>> searchArticles({
    required String query,
    required String searchIn,
    required String language,
  });
}

class RemoteDatasourceImpl implements RemoteDatasource {
  final http.Client _client;
  final String apiKey = Environment.newsApiKey;

  RemoteDatasourceImpl(this._client);

  @override
  Future<List<ArticleModel>> getArticles({
    required String page,
    required String category,
    required String country,
  }) async {
    try {
      final response =
          await _client.get(Uri.https(Urls.baseUrl, Urls.kGetArticlesEndpoint, {
        'apiKey': apiKey,
        'category': category,
        'country': country,
        'page': page,
      }));

      if (response.statusCode != 200) {
        throw ApiException(
            messagge: response.body, statusCode: response.statusCode);
      }

      return List<Map<String, dynamic>>.from(
              jsonDecode(response.body)["articles"] as List)
          .map((map) => ArticleModel.fromMap(map))
          .where((article) => article.title != '[Removed]' && article.url != null)
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles({
    required String query,
    required String searchIn,
    required String language,
  }) async {
    try {
      final response = await _client
          .get(Uri.https(Urls.baseUrl, Urls.kSearchArticlesEndpoint, {
        'apiKey': apiKey,
        'q': query,
        'searchIn': searchIn,
        'language': language,
      }));

      if (response.statusCode != 200) {
        throw ApiException(
            messagge: response.body, statusCode: response.statusCode);
      }

      return List<Map<String, dynamic>>.from(
              jsonDecode(response.body)["articles"] as List)
          .map((map) => ArticleModel.fromMap(map))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(messagge: e.toString(), statusCode: 500);
    }
  }
}
