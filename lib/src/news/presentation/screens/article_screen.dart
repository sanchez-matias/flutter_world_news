import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatefulWidget {
  final Article article;

  const ArticleScreen({
    super.key,
    required this.article,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool? isSaved;

  Future<void> _updateSavedButton() async {
    final bloc = BlocProvider.of<StorageBloc>(context);
    final value = await bloc.isArticleSaved(widget.article.url!);
    setState(() {
      isSaved = value;
    });
  }

  Future<void> _toggleSavedTrigger() async {
    context.read<StorageBloc>().add(ToggleSavedEvent(widget.article));
    await Future.delayed(const Duration(milliseconds: 100));
    await _updateSavedButton();
    setState(() {});
  }

  void _showCustomSnackBar(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    _updateSavedButton();
  }

  @override
  Widget build(BuildContext context) {
    final publishedAt = widget.article.publishedAt != null
        ? DateTime.parse(widget.article.publishedAt!)
        : DateTime.now();

    const fontFamily = 'NotoSerif';

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.article.sourceName!),
          actions: [
            IconButton(
              onPressed: () async {
                await _toggleSavedTrigger();
              },
              icon: isSaved == null
                  ? const Icon(Icons.error_outline)
                  : isSaved == true
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
                  widget.article.title!,
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
                child: Text(widget.article.description ?? 'No caption',
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
                image: NetworkImage(widget.article.urlToImage!),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.article.content!,
                  style: const TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(widget.article.url!);

                  if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
                    _showCustomSnackBar('Oops... could not open in browser');
                  }
                },
                icon: const Icon(Icons.read_more),
                label: const Text('Go to page'),
              ),
              const SizedBox(height: 40),
            ])));
  }
}
