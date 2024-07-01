import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';

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

  @override
  void initState() {
    super.initState();
    _updateSavedButton();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    final publishedAt = widget.article.publishedAt != null
        ? DateTime.parse(widget.article.publishedAt!)
        : DateTime.now();

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
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.article.title!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.article.description ?? 'No caption',
                  style: textStyle.titleSmall,
                ),
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
                  style: textStyle.bodyLarge,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
            ])));
  }
}
