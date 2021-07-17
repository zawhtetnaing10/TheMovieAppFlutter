import 'package:flutter/foundation.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class MovieDetailsBloc extends ChangeNotifier {
  /// State
  MovieVO mMovie;
  List<CreditVO> mActorsList;
  List<CreditVO> mCreatorsList;

  /// Model
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId) {
    /// Movie Details
    mMovieModel.getMovieDetails(movieId).then((movie) {
      this.mMovie = movie;
      notifyListeners();
    });

    /// Movie Details Database
    mMovieModel.getMovieDetailsFromDatabase(movieId).then((movie) {
      this.mMovie = movie;
      notifyListeners();
    });

    /// Credits
    mMovieModel.getCreditsByMovie(movieId).then((creditsList) {
      this.mActorsList =
          creditsList.where((credit) => credit.isActor()).toList();
      this.mCreatorsList =
          creditsList.where((credit) => credit.isCreator()).toList();
      notifyListeners();
    });
  }
}
