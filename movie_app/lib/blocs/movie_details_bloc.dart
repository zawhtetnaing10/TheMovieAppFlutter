import 'package:flutter/foundation.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

class MovieDetailsBloc extends ChangeNotifier {
  /// State
  MovieVO? mMovie;
  List<CreditVO>? mActorsList;
  List<CreditVO>? mCreatorsList;
  List<MovieVO>? mRelatedMovies;

  /// Model
  MovieModel mMovieModel = MovieModelImpl();

  MovieDetailsBloc(int movieId, [MovieModel? movieModel]) {
    if (movieModel != null) {
      mMovieModel = movieModel;
    }

    /// Movie Details
    mMovieModel.getMovieDetails(movieId)?.then((movie) {
      this.mMovie = movie;
      this.getRelatedMovies(movie?.genres?.first.id ?? 0);
      notifyListeners();
    });

    /// Movie Details Database
    mMovieModel.getMovieDetailsFromDatabase(movieId)?.then((movie) {
      this.mMovie = movie;
      notifyListeners();
    });

    /// Credits
    mMovieModel.getCreditsByMovie(movieId)?.then((creditsList) {
      this.mActorsList =
          creditsList?.where((credit) => credit.isActor()).toList();
      this.mCreatorsList =
          creditsList?.where((credit) => credit.isCreator()).toList();
      notifyListeners();
    });
  }

  void getRelatedMovies(int genreId) {
    mMovieModel.getMoviesByGenre(genreId)?.then((relatedMovies) {
      mRelatedMovies = relatedMovies;
      notifyListeners();
    });
  }
}
