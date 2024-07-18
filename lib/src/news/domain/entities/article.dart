class Article {
  final int? id; // This is the article id we are gonna access to interact with the DB.

  final String? author;
  final String? content;
  final String? description;
  final String? publishedAt;
  final String? sourceName;
  final String? title;
  final String? url;
  final String? urlToImage;

  const Article({
    this.id,

    this.author,
    this.content,
    this.description,
    this.publishedAt,
    this.sourceName,
    this.title,
    this.url,
    this.urlToImage,
  });
}
