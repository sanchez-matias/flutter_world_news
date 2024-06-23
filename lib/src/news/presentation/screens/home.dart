import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();

  void fetchMoreData() => context.read<RemoteBloc>().loadNextPage();

  @override
  void initState() {
    super.initState();

    fetchMoreData();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        fetchMoreData();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World News'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocBuilder<RemoteBloc, RemoteState>(
        builder: (context, state) {
          return ListView.builder(
            controller: controller,
            itemCount: state.articles.length + 1,
            itemBuilder: (context, index) {
              if (index < state.articles.length) {
                final item = state.articles[index];
                return ArticleCard(article: item);
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: _buildLastItem(state)),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildLastItem(RemoteState state) {
    final status = state.status;

    switch (status) {
      case RequestStatus.end:
        return const Text('No more articles aviable');

      case RequestStatus.failure:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('An error has ocurred. Please try again.'),
            const SizedBox(height:  20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Retry'),
            )
          ],
        );

      case RequestStatus.loading:
        return const CircularProgressIndicator.adaptive();

      default:
        return const SizedBox();
    }
  }
}
