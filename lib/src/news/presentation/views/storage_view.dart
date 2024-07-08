import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/delegates/remote_search_delegate.dart';
import 'package:flutter_world_news/src/news/presentation/screens/screens.dart';
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
    return BlocBuilder<StorageBloc, StorageState>(
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

        return ListView.builder(
            itemCount: state.articles.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _CustomHeaderButtons();
              }

              final item = state.articles[index - 1];

              return ArticleTile(
                article: item,
                onArticleSelected: (context, article) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleScreen(article: article),
                      ));
                },
              );
            });
      },
    );
  }
}

class _CustomHeaderButtons extends StatelessWidget {
  const _CustomHeaderButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.list_rounded),
            label: const Text('List: All'),
            style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(300, 30))),
          ),
        ],
      ),
    );
  }
}
