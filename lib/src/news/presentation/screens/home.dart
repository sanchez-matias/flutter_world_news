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

    final color = Theme.of(context).colorScheme;

    return Scaffold(
      body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    Icon(Icons.public, color: color.primary),
                    const SizedBox(width: 10),
                    const Text('World News'),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'settings');
                    },
                    icon: const Icon(Icons.settings),
                  ),
                ],
                bottom: const TabBar.secondary(tabs: [
                  Tab(child: Icon(Icons.home_rounded)),
                  Tab(child: Icon(Icons.bookmark_rounded)),
                ]),
              ),
            ],
            body: const TabBarView(children: [
              HomeView(),
              StorageView(),
            ]),
          )),
      
    );
  }

  @override
  bool get wantKeepAlive => true;
}
