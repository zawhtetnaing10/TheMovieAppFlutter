import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/dataagents/movie_data_agent.dart';
import 'package:movie_app/network/dataagents/retrofit_data_agent_impl.dart';
import 'package:movie_app/persistence/daos/actor_dao.dart';
import 'package:movie_app/persistence/daos/genre_dao.dart';
import 'package:movie_app/persistence/daos/movie_dao.dart';
import 'package:stream_transform/stream_transform.dart';

import 'movie_model.dart';

class MovieModelImpl extends MovieModel {
  MovieDataAgent mDataAgent = RetrofitDataAgentImpl();

  static final MovieModelImpl _singleton = MovieModelImpl._internal();

  factory MovieModelImpl() {
    return _singleton;
  }

  MovieModelImpl._internal();

  /// Daos
  MovieDao mMovieDao = MovieDao();
  GenreDao mGenreDao = GenreDao();
  ActorDao mActorDao = ActorDao();

  // Network
  @override
  void getNowPlayingMovies(int page) {
    mDataAgent.getNowPlayingMovies(page)?.then((movies) async {
      List<MovieVO>? nowPlayingMovies = movies?.map((movie) {
        movie.isNowPlaying = true;
        movie.isPopular = false;
        movie.isTopRated = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(nowPlayingMovies ?? []);
    });
  }

  @override
  Future<List<GenreVO>?>? getGenres() {
    return mDataAgent.getGenres()?.then((genres) async {
      mGenreDao.saveAllGenres(genres ?? []);
      return Future.value(genres);
    });
  }

  @override
  void getPopularMovies(int page) {
    mDataAgent.getPopularMovies(page)?.then((movies) async {
      List<MovieVO>? popularMovies = movies?.map((movie) {
        movie.isPopular = true;
        movie.isNowPlaying = false;
        movie.isTopRated = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(popularMovies ?? []);
    });
  }

  @override
  void getTopRatedMovies(int page) {
    mDataAgent.getTopRatedMovies(page)?.then((movies) async {
      List<MovieVO>? topRatedMovies = movies?.map((movie) {
        movie.isTopRated = true;
        movie.isPopular = false;
        movie.isNowPlaying = false;
        return movie;
      }).toList();
      mMovieDao.saveMovies(topRatedMovies ?? []);
    });
  }

  @override
  Future<List<MovieVO>?>? getMoviesByGenre(int genreId) {
    return mDataAgent.getMoviesByGenre(genreId);
  }

  @override
  Future<List<ActorVO>?>? getActors(int page) {
    return mDataAgent.getActors(page)?.then((actors) async {
      mActorDao.saveAllActors(actors ?? []);
      return Future.value(actors);
    });
  }

  @override
  Future<List<CreditVO>?>? getCreditsByMovie(int movieId) {
    return mDataAgent.getCreditsByMovie(movieId);
  }

  @override
  Future<MovieVO?>? getMovieDetails(int movieId) {
    return mDataAgent.getMovieDetails(movieId)?.then((movie) async {
      mMovieDao.saveSingleMovie(movie);
      return Future.value(movie);
    });
  }

  // Database
  @override
  Stream<List<MovieVO>> getTopRatedMoviesFromDatabase() {
    this.getTopRatedMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getTopRatedMoviesStream())
        .map((event) => mMovieDao.getTopRatedMovies());
  }

  @override
  Stream<List<MovieVO>> getNowPlayingMoviesFromDatabase() {
    this.getNowPlayingMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getNowPlayingMoviesStream())
        .map((event) => mMovieDao.getNowPlayingMovies());
  }

  @override
  Stream<List<MovieVO>> getPopularMoviesFromDatabase() {
    this.getPopularMovies(1);
    return mMovieDao
        .getAllMoviesEventStream()
        .startWith(mMovieDao.getPopularMoviesStream())
        .map((event) => mMovieDao.getPopularMovies());
  }

  @override
  Future<List<ActorVO>> getAllActorsFromDatabase() {
    return Future.value(mActorDao.getAllActors());
  }

  @override
  Future<MovieVO> getMovieDetailsFromDatabase(int movieId) {
    return Future.value(mMovieDao.getMovieById(movieId));
  }

  @override
  Future<List<GenreVO>> getGenresFromDatabase() {
    return Future<List<GenreVO>>.value(mGenreDao.getAllGenres());
  }
}
