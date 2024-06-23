import 'package:flutter_world_news/src/news/data/datasources/remote_datasource.dart';
import 'package:flutter_world_news/src/news/data/repositories/remote_repository_impl.dart';
import 'package:flutter_world_news/src/news/domain/repositories/remote_repository.dart';
import 'package:flutter_world_news/src/news/domain/usecases/get_articles.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App logic
    ..registerFactory(() => RemoteBloc(getArticles: sl()))

    // Usecases
    ..registerLazySingleton(() => GetArticles(sl()))

    // Repositories
    ..registerLazySingleton<RemoteRepository>(() => RemoteRepositoryImpl(sl()))

    // Data Sources
    ..registerLazySingleton<RemoteDatasource>(() => RemoteDatasourceImpl(sl()))

    // External dependencies
    ..registerLazySingleton(http.Client.new);
}