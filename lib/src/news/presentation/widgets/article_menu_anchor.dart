import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/tags_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleMenuAnchor extends StatelessWidget {
  final Widget child;
  final MenuController controller;
  final Article article;

  const ArticleMenuAnchor({
    super.key,
    required this.child,
    required this.controller,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final storageBloc = context.watch<StorageBloc>().state;
    final isArticleSaved = storageBloc.urls.contains(article.url);

    return MenuAnchor(
      consumeOutsideTap: true,
      menuChildren: <Widget>[
        MenuItemButton(
          leadingIcon:
              Icon(isArticleSaved ? Icons.bookmark : Icons.bookmark_outline),
          child: Text(isArticleSaved ? 'Delete' : 'Save'),
          onPressed: () {
            context.read<StorageBloc>().add(ToggleSavedEvent(article));
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.list),
          child: const Text('List Article'),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => TagsSheet(
                article: article,
              ),
            );
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.read_more),
          child: const Text('Source'),
          onPressed: () async {
            final uri = Uri.parse(article.url!);

            if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) return;
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.share),
          child: const Text('Share'),
          onPressed: () {
            Share.share(article.url!, subject: article.title);
          },
        ),
      ],
      controller: controller,
      child: child,
    );
  }
}
