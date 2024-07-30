import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';

class TagsSheet extends StatefulWidget {
  final Article article;

  const TagsSheet({super.key, required this.article});

  @override
  State<TagsSheet> createState() => _TagsSheetState();
}

class _TagsSheetState extends State<TagsSheet> {
  List<int> selectedTags = [];

  void getTagsForArticle() async {
    final newSelectedTags =
        await context.read<TagsCubit>().getTagsForArticle(widget.article);

    if (newSelectedTags != null) {
      selectedTags = newSelectedTags;
    } else {
      _showCustomSnackBar('Could not update tags');
    }

    setState(() {});
  }

  void toggleTagArticle({
    required String articleUrl,
    required int tagId,
  }) async {
    if (selectedTags.contains(tagId)) {
      context.read<TagsCubit>().untagArticle(
            articleUrl: articleUrl,
            tagId: tagId,
          );
    } else {
      context.read<TagsCubit>().tagArticle(
            articleUrl: articleUrl,
            tagId: tagId,
          );
    }

    await Future.delayed(const Duration(milliseconds: 100));
    getTagsForArticle();
  }

  void _showCustomSnackBar(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    getTagsForArticle();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tagsCubit = context.watch<TagsCubit>().state;
    final storageBloc = context.watch<StorageBloc>().state;
    final isArticleSaved = storageBloc.urls.contains(widget.article.url);

    return SizedBox(
      height: size.height * 0.5,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 30),
      
          ListTile(
              title: Text(isArticleSaved ? 'Article Saved' : 'Not saved'),
              trailing: IconButton.outlined(
                onPressed: () {
                  context
                      .read<StorageBloc>()
                      .add(ToggleSavedEvent(widget.article));
                  getTagsForArticle();
                },
                icon: Icon(
                  isArticleSaved ? Icons.bookmark : Icons.bookmark_outline,
                ),
              )),
      
          const _TitledDivider('Lists'),
      
          SizedBox(
            height: size.height * 0.3,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  tagsCubit.tags.length,
                  (index) {
                    final tag = tagsCubit.tags[index];
                  
                    return CheckboxListTile.adaptive(
                        title: Text(tag.name),
                        value: selectedTags.contains(tag.id),
                        onChanged: !isArticleSaved
                            ? null
                            : (value) {
                                toggleTagArticle(
                                    articleUrl: widget.article.url!, tagId: tag.id);
                              });
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TitledDivider extends StatelessWidget {
  final String msg;

  const _TitledDivider(this.msg);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Row(children: <Widget>[
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(msg, style: textStyle.titleMedium),
        ),
        const Expanded(child: Divider()),
      ]),
    );
  }
}
