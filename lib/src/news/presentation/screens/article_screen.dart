import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/tags_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatelessWidget {
  final Article article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  void _showCustomSnackBar({
    required BuildContext context,
    required String msg,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final storageBloc = context.watch<StorageBloc>().state;
    final isSaved = storageBloc.urls.contains(article.url);

    final publishedAt = article.publishedAt != null
        ? DateTime.parse(article.publishedAt!)
        : DateTime.now();

    const fontFamily = 'NotoSerif';

    return Scaffold(
        appBar: AppBar(
          title: Text(article.sourceName!),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TagsSheet(
                    article: article,
                  ),
                );
              },
              icon: const Icon(Icons.list),
            ),
            IconButton(
              onPressed: () async {
                context.read<StorageBloc>().add(ToggleSavedEvent(article));
              },
              icon: isSaved
                  ? const Icon(Icons.bookmark)
                  : const Icon(Icons.bookmark_outline),
            )
          ],
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Published: ${publishedAt.year}/${publishedAt.month}/${publishedAt.day}',
                  style: const TextStyle(
                    fontFamily: fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  article.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 10),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(article.description ?? 'No caption',
                    style: const TextStyle(
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
              ),

              const SizedBox(height: 20),

              FadeInImage(
                fit: BoxFit.cover,
                placeholderFit: BoxFit.none,
                height: 300,
                width: double.infinity,
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(article.urlToImage!),
              ),

              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  article.content!,
                  style: const TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse(article.url!);

                      if (!await launchUrl(
                        uri,
                        mode: LaunchMode.inAppBrowserView,
                      )) {
                        if (!context.mounted) return;
                        _showCustomSnackBar(
                          context: context,
                          msg: 'Oops... could not open in browser',
                        );
                      }
                    },
                    icon: const Icon(Icons.read_more),
                    label: const Text('Go to page'),
                  ),

                  const SizedBox(width: 20),

                  OutlinedButton.icon(
                    onPressed: () {
                      Share.share(article.url!, subject: article.title);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  )
                ],
              ),
              const SizedBox(height: 40),
            ])));
  }
}
