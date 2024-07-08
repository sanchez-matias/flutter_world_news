import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_tile.dart';

enum SearchType {local, remote}

class CustomSearchDelegate extends SearchDelegate<Article?> {
  final SearchType searchType;

  CustomSearchDelegate(this.searchType);

  Widget _buildLocalSearch(BuildContext context, String query) {
    context.read<LocalSearchCubit>().searchDbArticles(query);

    return BlocBuilder<LocalSearchCubit, LocalSearchState>(
      builder: (context, state) {
        switch (state.searchStatus) {
          case (LocalSearchStatus.failure):
            return const Center(
              child: Text('There was a failure on the DB'),
            );

          case (LocalSearchStatus.loading):
            return const Center(child: CircularProgressIndicator());

          case (LocalSearchStatus.success):
          
            if (state.articles.isEmpty) {
              return const Center(
                child: Text('There are no matching articles'),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                final item = state.articles[index];

                return ArticleTile(
                  article: item,
                  onArticleSelected: (context, item) {
                    close(context, item);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: state.articles.length,
            );

          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildRemoteSearch(BuildContext context, String query) {
    context.read<RemoteSearchCubit>().searchArticles(query: query);

    return BlocBuilder<RemoteSearchCubit, RemoteSearchState>(
      builder: (context, state) {
        switch (state.status) {
          case (RemoteSearchStatus.failure):
            return const Center(
              child: Text('There was a failure searching articles'),
            );

          case (RemoteSearchStatus.loading):
            return const Center(child: CircularProgressIndicator());

          case (RemoteSearchStatus.success):
          
            if (state.articles.isEmpty) {
              return const Center(
                child: Text('There are no coincidences'),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                final item = state.articles[index];

                return ArticleTile(
                  article: item,
                  onArticleSelected: (context, item) {
                    close(context, item);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: state.articles.length,
            );

          default:
            return const SizedBox();
        }
      },
    );
  }

  @override
  String? get searchFieldLabel {
    switch (searchType) {
      case (SearchType.remote):
        return 'Search online';

      case (SearchType.local):
        return 'Search locally';
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded));

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') return const SizedBox();

    switch (searchType) {
      case (SearchType.remote):
        return _buildRemoteSearch(context, query);
      case (SearchType.local):
        return _buildLocalSearch(context, query);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}

