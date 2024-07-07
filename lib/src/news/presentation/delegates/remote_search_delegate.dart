import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';

class RemoteSearchDelegate extends SearchDelegate<Article?> {
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
                child: Text('There is no coincidences'),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                final item = state.articles[index];

                return _ResultItem(
                  article: item,
                  onMovieSelected: (context, item) {
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
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }
}

class _ResultItem extends StatelessWidget {
  final Article article;
  final Function onMovieSelected;

  const _ResultItem({
    required this.article,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, article),
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
                    placeholder: const AssetImage('assets/loading.gif'),
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
                      style: textStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textStyles.bodyMedium,
                    ),

                    const SizedBox(height: 15),

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
