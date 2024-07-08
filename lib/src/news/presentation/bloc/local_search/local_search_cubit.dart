import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/usecases/storage/search_article.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';

part 'local_search_state.dart';

class LocalSearchCubit extends Cubit<LocalSearchState> {
  final SearchArticle _searchArticle;

  LocalSearchCubit({
    required SearchArticle searchArticle,
  })  : _searchArticle = searchArticle,
        super(const LocalSearchState());

  Future<void> searchDbArticles(String query) async {
    emit(state.copyWith(searchStatus: LocalSearchStatus.loading));

    final resut = await _searchArticle(query);

    resut.fold(
      (failure) => emit(state.copyWith(searchStatus: LocalSearchStatus.failure)),
      (articles) => emit(state.copyWith(
        searchStatus: LocalSearchStatus.success,
        articles: articles,
      )),
    );
  }
}
