import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_world_news/src/news/domain/entities/article.dart';
import 'package:flutter_world_news/src/news/domain/usecases/get_articles.dart';

part 'remote_event.dart';
part 'remote_state.dart';

class RemoteBloc extends Bloc<RemoteEvent, RemoteState> {
  final GetArticles _getArticles;
  int page = 0;

  RemoteBloc({required GetArticles getArticles})
      : _getArticles = getArticles,
        super(const RemoteState()) {
    on<GetArticlesEvent>(_onGetArticlesHandler);

    on<ChangeCountry>(_onChangeCountryHandler);

    on<ChangeCategory>(_onChangeCategoryHandler);
  }

  void loadNextPage() {
    if (state.status != RequestStatus.success &&
        state.status != RequestStatus.initial) return;
    add(GetArticlesEvent(page));
  }

  Future<void> _onGetArticlesHandler(
    GetArticlesEvent event,
    Emitter<RemoteState> emit,
  ) async {
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _getArticles(GetArticlesParams(
      page: event.page.toString(),
      category: state.category,
      country: state.country,
    ));

    result.fold(
      (failure) => emit(state.copyWith(status: RequestStatus.failure)),
      (articles) => emit(state.copyWith(
        // When we reach the end of the API pages we will get an empty list if we
        // try to get the next page.
        status: articles.isEmpty ? RequestStatus.end : RequestStatus.success,
        articles: [...state.articles, ...articles],
      )),
    );

    page++;
  }

  void _onChangeCountryHandler(
      ChangeCountry event, Emitter<RemoteState> emit) {}

  void _onChangeCategoryHandler(
      ChangeCategory event, Emitter<RemoteState> emit) {}
}
