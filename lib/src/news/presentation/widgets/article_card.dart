import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/screens/article_screen.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_menu_anchor.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final controller = MenuController();
    final colors = Theme.of(context).colorScheme;
    final storageBloc = context.watch<StorageBloc>().state;
    final isArticleSaved = storageBloc.urls.contains(article.url);

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

              isArticleSaved
                  ? Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: Row(
                        children: [
                          Icon(Icons.bookmark, color: colors.primary),
                          const SizedBox(width: 5),
                          const Text('Article Saved'),
                        ],
                      ),
                  )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
