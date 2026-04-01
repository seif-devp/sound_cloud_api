part of 'home_page_cubit.dart';

sealed class HomePageState {}

final class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

final class HomePageLoaded extends HomePageState {
  final List<dynamic> photos;
  HomePageLoaded(this.photos);
}

final class HomePageError extends HomePageState {
  final String message;
  HomePageError(this.message);
}
class CategorySelected {
  final bool isSelected;
  CategorySelected({required this.isSelected});
}
