part of 'storage_bloc.dart';

sealed class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => [];
}

class GetFromDb extends StorageEvent {}

class SearchArticleEvent extends StorageEvent {
  final String query;

  const SearchArticleEvent(this.query);
}

class ToggleSavedEvent extends StorageEvent {
  final Article article;

  const ToggleSavedEvent(this.article);
}
