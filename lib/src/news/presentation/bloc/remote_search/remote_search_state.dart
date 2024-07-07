part of 'remote_search_cubit.dart';

enum RemoteSearchStatus { loading, success, failure }

class RemoteSearchState extends Equatable {
  final RemoteSearchStatus status;
  final List<Article> articles;
  final String language;
  final String searchIn;

  List<String?> get urls => articles.map((a) => a.url).toList();

  const RemoteSearchState({
    this.status = RemoteSearchStatus.loading,
    this.articles = const [],
    this.language = 'en',
    this.searchIn = 'title,content',
  });

  RemoteSearchState copyWith({
    RemoteSearchStatus? status,
    List<Article>? articles,
    String? language,
    String? searchIn,
  }) =>
      RemoteSearchState(
        status: status ?? this.status,
        articles: articles ?? this.articles,
        language: language ?? this.language,
        searchIn: searchIn ?? this.searchIn,
      );

  @override
  List<Object> get props => [status, urls];
}
