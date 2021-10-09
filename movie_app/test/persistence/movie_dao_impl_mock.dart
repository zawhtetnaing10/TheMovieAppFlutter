import 'dart:async';

import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';

class MovieDaoImplMock extends MovieDao {
  Map<int, MovieVO> moviesInDatabaseMock = {};
  StreamController<void> getAllMoviesEventStreamControllerMock =
      StreamController();

  @override
  List<MovieVO> getAllMovies() {
    return moviesInDatabaseMock.values.toList();
  }

  @override
  Stream<void> getAllMoviesEventStream() {
    return getAllMoviesEventStreamControllerMock.stream;
  }

  @override
  MovieVO? getMovieById(int movieId) {
    return moviesInDatabaseMock.values
        .toList()
        .firstWhere((element) => element.id == movieId);
  }

  @override
  List<MovieVO> getNowPlayingMovies() {
    if ((getAllMovies().isNotEmpty)) {
      return getAllMovies()
          .where((element) => element.isPopular ?? false)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isNowPlaying ?? false)
        .toList());
  }

  @override
  List<MovieVO> getPopularMovies() {
    if (getAllMovies() != null && (getAllMovies().isNotEmpty ?? false)) {
      return getAllMovies()
          .where((element) => element?.isPopular ?? false)
          .toList();
    } else {
      return [];
    }
    ;
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isPopular ?? false)
        .toList());
  }

  @override
  List<MovieVO> getTopRatedMovies() {
    if (getAllMovies() != null && (getAllMovies().isNotEmpty ?? false)) {
      return getAllMovies()
          .where((element) => element?.isTopRated ?? false)
          .toList();
    } else {
      return [];
    }
  }

  @override
  Stream<List<MovieVO>> getTopRatedMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isTopRated ?? false)
        .toList());
  }

  @override
  void saveMovies(List<MovieVO> movies) {
    movies.forEach((movie) {
      moviesInDatabaseMock[movie.id] = movie;
    });
    getAllMoviesEventStreamControllerMock.sink.add(null);
  }

  @override
  void saveSingleMovie(MovieVO? movie) {
    if (movie != null) {
      moviesInDatabaseMock[movie.id] = movie;
    }
  }

  void closeStreamController() {
    getAllMoviesEventStreamControllerMock.close();
  }
}
