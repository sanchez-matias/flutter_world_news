import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/delegates/remote_search_delegate.dart';
import 'package:flutter_world_news/src/news/presentation/screens/screens.dart';
import 'package:flutter_world_news/src/news/presentation/widgets/article_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
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
    super.build(context);

    return Scaffold(
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
        onPressed: () {
          showSearch(context: context, delegate: RemoteSearchDelegate())
              .then((article) {
            if (article == null) return;

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleScreen(article: article),
                ));
          });
        },
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
            const SizedBox(height: 20),
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

  @override
  bool get wantKeepAlive => true;
}
