part of 'storage_bloc.dart';

enum StorageStatus { initial, failure, success }

class StorageState extends Equatable {
  final List<Article> articles;
  final StorageStatus status;

  const StorageState({
    this.articles = const [],
    this.status = StorageStatus.initial,
  });

  StorageState copyWith({
    List<Article>? articles,
    StorageStatus? status,
  }) =>
      StorageState(
        articles: articles ?? this.articles,
        status: status ?? this.status,
      );

  @override
  List<Object> get props => [articles, status];
}
