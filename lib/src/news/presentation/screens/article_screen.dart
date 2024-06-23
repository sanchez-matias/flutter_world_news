import 'package:flutter/material.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final publishedAt = article.publishedAt != null
        ? DateTime.parse(article.publishedAt!)
        : DateTime.now();


    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName!),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Published: ${publishedAt.year}/${publishedAt.month}/${publishedAt.day}',
                textAlign: TextAlign.left,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article.title!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article.description ?? 'No caption',
                style: textStyle.titleSmall,
              ),
            ),

            const SizedBox(height: 20),

            Image.network(
              article.urlToImage ??
                  'https://t4.ftcdn.net/jpg/02/51/13/11/360_F_251131195_YKAgbS5YEeDSUmNg69MtEOV3OYxrM2ml.jpg',
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                article.content!,
                style: textStyle.bodyLarge,
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 20),
          ]
        )
      )
    );
  }
}
