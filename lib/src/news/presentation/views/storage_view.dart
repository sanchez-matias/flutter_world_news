import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/delegates/custom_search_delegate.dart';
import 'package:flutter_world_news/src/news/presentation/screens/screens.dart';
import 'package:flutter_world_news/src/news/presentation/screens/tags_screen.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_tile.dart';

class StorageView extends StatefulWidget {
  const StorageView({super.key});

  @override
  State<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends State<StorageView> {
  void _getArticlesFromDb() {
    context.read<StorageBloc>().add(GetFromDb());
  }

  @override
  void initState() {
    super.initState();
    _getArticlesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SafeArea(child: _CustomHeaderButtons()),
        
        BlocBuilder<StorageBloc, StorageState>(
          builder: (context, state) {
            if (state.status == StorageStatus.failure) {
              return const Center(
                child: Text('There was a failure'),
              );
            }

            if (state.status == StorageStatus.initial) {
              return const Center(
                child: Text('Loading your Saved Articles'),
              );
            }

            if (state.articles.isEmpty) {
              return const Center(
                child: Text('There is no saved articles'),
              );
            }

            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    final item = state.articles[index];

                    return Slidable(
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            spacing: 2,
                            onPressed: (context) {
                              context
                                  .read<StorageBloc>()
                                  .add(ToggleSavedEvent(item));
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ArticleTile(
                        article: item,
                        onArticleSelected: (context, article) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticleScreen(article: article),
                              ));
                        },
                      ),
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}

class _CustomHeaderButtons extends StatelessWidget {
  const _CustomHeaderButtons();

  @override
  Widget build(BuildContext context) {
    final tagsCubit = context.watch<TagsCubit>().state.tags;
    final selectedTag = context.watch<StorageBloc>().state.selectedTag;
    final selectedTagName = selectedTag == 0
        ? 'All'
        : tagsCubit.firstWhere((element) => element.id == selectedTag).name;

    Future<void> showTagSelectorDialog() async => await showDialog<int>(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: const Text('Select a List'),
            scrollable: true,
            content: SizedBox(
              width: 250,
              child: BlocBuilder<TagsCubit, TagsState>(
                builder: (context, state) {
                  final tags = state.tags;

                  return Column(
                    children: [
                      ListTile(
                        title: const Text('All'),
                        onTap: () {
                          context
                              .read<StorageBloc>()
                              .add(const ChangeSelectedList(0));
                          Navigator.of(context).pop();
                        },
                      ),
                      ...List.generate(
                        tags.length,
                        (index) => ListTile(
                          title: Text(tags[index].name),
                          // trailing: Text(tags[index].isModifiable.toString()),
                          onTap: () {
                            context
                                .read<StorageBloc>()
                                .add(ChangeSelectedList(tags[index].id));
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            actions: [
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const TagsScreen(),
                  ));
                },
                label: const Text('Manage Lists'),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Search
          OutlinedButton.icon(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(SearchType.local),
              ).then((article) {
                if (article == null) return;

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleScreen(article: article),
                    ));
              });
            },
            label: const Text('Search'),
            icon: const Icon(Icons.search),
          ),

          const SizedBox(width: 15),

          // Lists Filter
          FilledButton.icon(
              onPressed: () async {
                await showTagSelectorDialog();
              },
              icon: const Icon(Icons.list_rounded),
              label: Text('List: $selectedTagName'),
              style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(300, 30)))),
        ],
      ),
    );
  }
}
