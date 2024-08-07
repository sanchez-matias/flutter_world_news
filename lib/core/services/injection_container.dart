import 'package:flutter_world_news/src/news/data/datasources/datasources.dart';
import 'package:flutter_world_news/src/news/data/repositories/repository_impls.dart';
import 'package:flutter_world_news/src/news/domain/repositories/repositories.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // App logic
    ..registerFactory(() => RemoteBloc(getArticles: sl()))
    ..registerFactory(() => StorageBloc(
          getArticles: sl(),
          isArticleSaved: sl(),
          toggleSaved: sl(),
        ))
    ..registerFactory(() => RemoteSearchCubit(searchArticles: sl()))
    ..registerFactory(() => LocalSearchCubit(searchArticle: sl()))
    ..registerFactory(() => TagsCubit(
          getTags: sl(),
          createTag: sl(),
          updateTag: sl(),
          deleteTag: sl(),
          tagArticle: sl(),
          untagArticle: sl(),
          getTagsForArticle: sl()
        )..getTags())

    // Usecases
    ..registerLazySingleton(() => GetArticles(sl()))
    ..registerLazySingleton(() => SearchArticles(sl()))
    ..registerLazySingleton(() => GetStorageArticles(sl()))
    ..registerLazySingleton(() => IsArticleSaved(sl()))
    ..registerLazySingleton(() => SearchArticle(sl()))
    ..registerLazySingleton(() => ToggleSaved(sl()))
    ..registerLazySingleton(() => GetTags(sl()))
    ..registerLazySingleton(() => CreateTag(sl()))
    ..registerLazySingleton(() => UpdateTag(sl()))
    ..registerLazySingleton(() => DeleteTag(sl()))
    ..registerLazySingleton(() => TagArticle(sl()))
    ..registerLazySingleton(() => UntagArticle(sl()))
    ..registerLazySingleton(() => GetTagsForArticle(sl()))

    // Repositories
    ..registerLazySingleton<RemoteRepository>(() => RemoteRepositoryImpl(sl()))
    ..registerLazySingleton<StorageRepository>(
        () => StorageRepositoryImpl(sl()))

    // Data Sources
    ..registerLazySingleton<RemoteDatasource>(() => RemoteDatasourceImpl(sl()))
    ..registerLazySingleton<StorageDatasource>(() => StorageDatasourceImpl())

    // External dependencies
    ..registerLazySingleton(http.Client.new);
}
