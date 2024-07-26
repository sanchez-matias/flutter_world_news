part of 'storage_bloc.dart';

enum StorageStatus { initial, failure, success }

class StorageState extends Equatable {
  final List<Article> articles;
  final StorageStatus status;
  final int selectedTag;

  const StorageState({
    this.articles = const [],
    this.status = StorageStatus.initial,
    this.selectedTag = 0,
  });

  List<String> get urls => articles.map((article) => article.url!).toList();

  StorageState copyWith({
    List<Article>? articles,
    StorageStatus? status,
    int? selectedTag,
  }) =>
      StorageState(
        articles: articles ?? this.articles,
        status: status ?? this.status,
        selectedTag: selectedTag ?? this.selectedTag,
      );

  @override
  List<Object> get props => [articles, status, selectedTag];
}
