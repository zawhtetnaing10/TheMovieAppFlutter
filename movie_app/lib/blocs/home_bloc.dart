import 'dart:async';

import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class HomeBloc {
  /// Reactive Streams
  StreamController<List<MovieVO>> mNowPlayingStreamController;
  StreamController<List<MovieVO>> mPopularMoviesListStreamController;
  StreamController<List<GenreVO>> mGenreListStreamController;
  StreamController<List<ActorVO>> mActorsStreamController;
  StreamController<List<MovieVO>> mShowCaseMovieListStreamController;
  StreamController<List<MovieVO>> mMoviesByGenreListStreamController;

  void dispose() {
    mNowPlayingStreamController.close();
    mPopularMoviesListStreamController.close();
    mGenreListStreamController.close();
    mActorsStreamController.close();
    mShowCaseMovieListStreamController.close();
    mMoviesByGenreListStreamController.close();
  }
}
