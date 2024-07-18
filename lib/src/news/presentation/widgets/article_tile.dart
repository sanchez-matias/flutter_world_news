import 'package:flutter/material.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  final Function onArticleSelected;

  const ArticleTile({
    super.key,
    required this.article,
    required this.onArticleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const fontFamily = 'NotoSerif';

    return GestureDetector(
      onTap: () => onArticleSelected(context, article),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    height: 130,
                    fit: BoxFit.cover,
                    image: NetworkImage(article.urlToImage!),
                    placeholder: const AssetImage('assets/loaders/loading.gif'),
                  )),
            ),

            const SizedBox(width: 10),

            SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title!,
                      style: const TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: fontFamily,

                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      article.sourceName!.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
