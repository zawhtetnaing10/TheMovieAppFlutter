import 'dart:async';

import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc {
  /// Stream Controllers
  StreamController<MovieVO?> movieStreamController =
      StreamController.broadcast();
  BehaviorSubject<List<CreditVO>?> creatorsStreamController = BehaviorSubject();
  StreamController<List<CreditVO>?> actorsStreamController =
      StreamController.broadcast();

  /// Models
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    /// Movie Details
    mMovieModel.getMovieDetails(movieId).then((movie) {
      movieStreamController.sink.add(movie);
    });

    /// Movie Details Database
    mMovieModel.getMovieDetailsFromDatabase(movieId).then((movie) {
      movieStreamController.sink.add(movie);
    });

    mMovieModel.getCreditsByMovie(movieId).asStream().listen((creditsList) {
      actorsStreamController.sink
          .add(creditsList.where((credit) => credit.isActor()).toList());
      creatorsStreamController
          .add(creditsList.where((credit) => credit.isCreator()).toList());
    });
  }

  void disposeStreams() {
    movieStreamController.close();
    creatorsStreamController.close();
    actorsStreamController.close();
  }
}
