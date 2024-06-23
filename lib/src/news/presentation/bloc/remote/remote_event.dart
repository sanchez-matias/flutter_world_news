part of 'remote_bloc.dart';

sealed class RemoteEvent extends Equatable {
  const RemoteEvent();

  @override
  List<Object> get props => [];
}

class GetArticlesEvent extends RemoteEvent {
  final int page;

  const GetArticlesEvent(this.page);
}

class ChangeCountry extends RemoteEvent {
  final String newCountyCode;

  const ChangeCountry(this.newCountyCode);
}

class ChangeCategory extends RemoteEvent {
  final String newCategoryName;

  const ChangeCategory(this.newCategoryName);
}