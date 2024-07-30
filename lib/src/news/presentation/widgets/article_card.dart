import 'package:flutter/material.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/screens/article_screen.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_menu_anchor.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({super.key, required this.article,});

  final controller = MenuController();

  @override
  Widget build(BuildContext context) {
    return ArticleMenuAnchor(
      article: article,
      controller: controller,
      child: Card.outlined(
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        child: InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
              return;
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleScreen(article: article),
                ));
          },

          onLongPress: () {
            controller.open(position: const Offset(270, 250));
          },

          child: Column(
            children: [
              FadeInImage(
                fit: BoxFit.cover,
                placeholderFit: BoxFit.none,
                height: 250,
                width: double.infinity,
                placeholder: const AssetImage('assets/loaders/loading.gif'),
                image: NetworkImage(article.urlToImage!),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  article.title!,
                  style: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
