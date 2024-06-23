import 'package:flutter/material.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/screens/article_screen.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card.outlined(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(article: article),
            ));
        },
        child: Column(
          children: [
            FadeInImage(
              fit: BoxFit.cover,
              placeholderFit: BoxFit.none,
              height: 250,
              width: double.infinity,
              placeholder: const AssetImage('assets/loading.gif'),
              image: NetworkImage(article.urlToImage!),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                article.title!,
                style: textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}