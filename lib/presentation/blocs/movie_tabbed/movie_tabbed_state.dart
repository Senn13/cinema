part of 'movie_tabbed_bloc.dart';

sealed class MovieTabbedState extends Equatable {
  final int currentTabIndex;

  const MovieTabbedState({required this.currentTabIndex});
  
  @override
  List<Object> get props => [];
}

class MovieTabbedInitial extends MovieTabbedState {
  const MovieTabbedInitial() : super(currentTabIndex: 0);
}

class MovieTabChanged extends MovieTabbedState {
  final List<MovieEntity> movies;

  const MovieTabChanged({required int currentTabIndex, required this.movies})
      : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex, movies];
}

class MovieTabLoadError extends MovieTabbedState {
  const MovieTabLoadError({required int currentTabIndex})
      : super(currentTabIndex: currentTabIndex);
}
