import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/screens/screens.dart';

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
          itemCount: state.articles.length,
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArticleScreen(article: state.articles[index]),
                  ));
            },
            title: Text(
              state.articles[index].title!,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              state.articles[index].description!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
