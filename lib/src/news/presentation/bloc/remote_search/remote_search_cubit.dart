import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/usecases/usecases.dart';

part 'remote_search_state.dart';

class RemoteSearchCubit extends Cubit<RemoteSearchState> {
  final SearchArticles _searchArticles;

  RemoteSearchCubit({
    required SearchArticles searchArticles,
  })  : _searchArticles = searchArticles,
        super(const RemoteSearchState());

  Future<void> searchArticles({
    required String query,
  }) async {
    emit(state.copyWith(status: RemoteSearchStatus.loading, articles: []));

    final result = await _searchArticles(SearchArticlesParams(
      query: query,
      searchIn: state.searchIn,
      language: state.language,
    ));

    result.fold(
        (failure) => emit(state.copyWith(status: RemoteSearchStatus.failure)),
        (articles) => emit(state.copyWith(
              status: RemoteSearchStatus.success,
              articles: articles,
            )));
  }
}
