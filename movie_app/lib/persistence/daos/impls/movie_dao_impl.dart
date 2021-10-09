import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';
import 'package:movie_app/persistence/hive_constants.dart';

class MovieDaoImpl extends MovieDao {
  static final MovieDaoImpl _singleton = MovieDaoImpl._internal();

  factory MovieDaoImpl() {
    return _singleton;
  }

  MovieDaoImpl._internal();

  @override
  void saveMovies(List<MovieVO> movies) async {
    Map<int, MovieVO> movieMap = Map.fromIterable(movies,
        key: (movie) => movie.id, value: (movie) => movie);
    await _getMovieBox().putAll(movieMap);
  }

  @override
  void saveSingleMovie(MovieVO? movie) async {
    if (movie != null) {
      return _getMovieBox().put(movie.id, movie);
    }
  }

  @override
  MovieVO? getMovieById(int movieId) {
    return _getMovieBox().get(movieId);
  }

  @override
  List<MovieVO> getAllMovies() {
    return _getMovieBox().values.toList();
  }

  /// Reactive Programming
  @override
  Stream<void> getAllMoviesEventStream() {
    return _getMovieBox().watch();
  }

  @override
  Stream<List<MovieVO>> getNowPlayingMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isNowPlaying ?? false)
        .toList());
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isPopular ?? false)
        .toList());
  }

  @override
  Stream<List<MovieVO>> getTopRatedMoviesStream() {
    return Stream.value(getAllMovies()
        .where((element) => element?.isTopRated ?? false)
        .toList());
  }

  @override
  List<MovieVO> getNowPlayingMovies() {
    if (getAllMovies() != null && (getAllMovies().isNotEmpty ?? false)) {
      return getAllMovies()
          .where((element) => element?.isNowPlaying ?? false)
          .toList();
    } else {
      return [];
    }
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

  Box<MovieVO> _getMovieBox() {
    return Hive.box<MovieVO>(BOX_NAME_MOVIE_VO);
  }
}
