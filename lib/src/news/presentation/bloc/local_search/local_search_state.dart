part of 'local_search_cubit.dart';

enum LocalSearchStatus {loading, success, failure}

class LocalSearchState extends Equatable {
  final LocalSearchStatus searchStatus;
  final List<Article> articles;
  final String searchIn;

  const LocalSearchState({
    this.searchStatus = LocalSearchStatus.loading,
    this.articles = const [],
    this.searchIn = 'title'
  });

  LocalSearchState copyWith({
    LocalSearchStatus? searchStatus,
    List<Article>? articles,
    String? searchIn,
  }) => LocalSearchState(
    searchStatus: searchStatus ?? this.searchStatus,
    articles: articles ?? this.articles,
    searchIn: searchIn ?? this.searchIn,
  );

  @override
  List<Object> get props => [articles, searchIn, searchStatus];
}

