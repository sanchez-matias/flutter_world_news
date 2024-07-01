import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  final GetStorageArticles _getArticles;
  final IsArticleSaved _isArticleSaved;
  final SearchArticle _searchArticle;
  final ToggleSaved _toggleSaved;

  StorageBloc({
    required GetStorageArticles getArticles,
    required IsArticleSaved isArticleSaved,
    required SearchArticle searchArticle,
    required ToggleSaved toggleSaved,
  })  : _getArticles = getArticles,
        _isArticleSaved = isArticleSaved,
        _searchArticle = searchArticle,
        _toggleSaved = toggleSaved,
        super(const StorageState()) {
    on<GetFromDb>(_onGetArticlesHandler);
    on<SearchArticleEvent>(_onSearchArticleHandler);
    on<ToggleSavedEvent>(_onToggleSavedHandler);
  }

  Future<bool?> isArticleSaved(String url) async {
    final isSaved = await _isArticleSaved(url);
    final bool? response = isSaved.fold((l) => null, (r) => r);

    return response;
  }

  Future<void> _onGetArticlesHandler(
      GetFromDb event, Emitter<StorageState> emit) async {
    final articles = await _getArticles();

    articles.fold(
      (failure) => emit(state.copyWith(status: StorageStatus.failure)),
      (articles) => emit(state.copyWith(
        status: StorageStatus.success,
        articles: articles,
      )),
    );
  }

  Future<void> _onSearchArticleHandler(
      SearchArticleEvent event, Emitter<StorageState> emit) async {}

  Future<void> _onToggleSavedHandler(
      ToggleSavedEvent event, Emitter<StorageState> emit) async {
    final result = await _toggleSaved(event.article);

    result.fold(
      (failure) => emit(state.copyWith(status: StorageStatus.failure)),
      (res) => add(GetFromDb()),
    );
  }
}
