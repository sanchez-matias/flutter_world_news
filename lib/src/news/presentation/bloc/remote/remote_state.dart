part of 'remote_bloc.dart';

enum RequestStatus { initial, loading, failure, success, end }

class RemoteState extends Equatable {
  final RequestStatus status;
  final List<Article> articles;
  final String country;
  final String category;

  const RemoteState({
    this.status = RequestStatus.initial,
    this.articles = const [],
    this.country = 'us',
    this.category = 'general',
  });

  RemoteState copyWith({
    RequestStatus? status,
    List<Article>? articles,
    String? country,
    String? category,
  }) =>
      RemoteState(
        status: status ?? this.status,
        articles: articles ?? this.articles,
        country: country ?? this.country,
        category: category ?? this.category,
      );

  @override
  List<Object> get props => [status, articles, country, category];
}
