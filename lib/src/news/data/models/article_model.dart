import 'dart:convert';

import 'package:flutter_world_news/src/news/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.author,
    required super.content,
    required super.description,
    required super.publishedAt,
    required super.sourceName,
    required super.title,
    required super.url,
    required super.urlToImage,
  });

  const ArticleModel.empty()
      : this(
          author: '_author.empty',
          content: '_content.empty',
          description: '_description.empty',
          publishedAt: '_publishedAt.empty',
          sourceName: '_sourceName.empty',
          title: '_title.empty',
          url: '_url.empty',
          urlToImage: '_urlToImage.empty',
        );

  factory ArticleModel.fromJson(String source) =>
      ArticleModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  ArticleModel.fromMap(Map<String, dynamic> map)
      : this(
          author: map["author"] ?? 'Author not povided',
          content: map["content"] ?? 'No content given',
          description: map["description"] ?? 'No description given',
          publishedAt: map["publishedAt"] ?? 'Unknown date',
          sourceName: map["source"]["name"] ?? "Not provided",
          title: map["title"] ?? 'Untitled',
          url: map["url"],
          urlToImage: map["urlToImage"] ?? 'https://th.bing.com/th/id/OIP.30oAyXf6XizSRpaa63TRuwHaFE?rs=1&pid=ImgDetMain',
        );

  Map<String, dynamic> toMap() => {
        "author": author,
        "content": content,
        "description": description,
        "publishedAt": publishedAt,
        "source": {
          "id": null,
          "name": sourceName
        },
        "title": title,
        "url": url,
        "urlToImage": urlToImage,
      };

  String toJson() => jsonEncode(toMap());

  ArticleModel copyWith({
    String? author,
    String? content,
    String? description,
    String? publishedAt,
    String? sourceName,
    String? title,
    String? url,
    String? urlToImage,
  }) =>
      ArticleModel(
        author: author ?? this.author,
        content: content ?? this.content,
        description: description ?? this.description,
        publishedAt: publishedAt ?? this.publishedAt,
        sourceName: sourceName ?? this.sourceName,
        title: title ?? this.title,
        url: url ?? this.url,
        urlToImage: urlToImage ?? this.urlToImage,
      );
}