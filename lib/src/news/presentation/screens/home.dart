import 'package:flutter/material.dart';
import 'package:flutter_world_news/src/news/presentation/views/views.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                centerTitle: true,
                title: const Text('World News'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ],
                bottom: const TabBar(tabs: [
                  Tab(child: Icon(Icons.category_rounded)),
                  Tab(child: Icon(Icons.home_rounded)),
                  Tab(child: Icon(Icons.bookmark_rounded)),
                ]),
              ),
            ],
            body: const TabBarView(children: [
              CategoriesView(),
              HomeView(),
              StorageView(),
            ]),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.search),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
