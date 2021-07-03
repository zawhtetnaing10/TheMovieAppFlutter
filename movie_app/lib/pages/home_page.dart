import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/banner_view.dart';
import 'package:movie_app/viewitems/movie_view.dart';
import 'package:movie_app/viewitems/showcase_view.dart';
import 'package:movie_app/widgets/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_text.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieModel mMovieModel = MovieModelImpl();

  List<MovieVO> mNowPlayingMovieList;
  List<MovieVO> mPopularMoviesList;
  List<GenreVO> mGenreList;
  List<ActorVO> mActors;
  List<MovieVO> mShowCaseMovieList;
  List<MovieVO> mMoviesByGenreList;

  @override
  void initState() {
    super.initState();

    // /// Now Playing Movies
    // mMovieModel.getNowPlayingMovies(1).then((movieList) {
    //   setState(() {
    //     mNowPlayingMovieList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Now Playing Movies Database
    mMovieModel.getNowPlayingMoviesFromDatabase().then((movieList) {
      setState(() {
        mNowPlayingMovieList = movieList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    // /// Popular Movies
    // mMovieModel.getPopularMovies(1).then((movieList) {
    //   setState(() {
    //     mPopularMoviesList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Popular Movies Database
    mMovieModel.getPopularMoviesFromDatabase().then((movieList) {
      setState(() {
        mPopularMoviesList = movieList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Genres
    mMovieModel.getGenres().then((genreList) {
      setState(() {
        mGenreList = genreList;

        /// Movies By Genre
        _getMoviesByGenreAndRefresh(mGenreList.first.id);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Genres Database
    mMovieModel.getGenresFromDatabase().then((genreList) {
      setState(() {
        mGenreList = genreList;

        /// Movies By Genre
        _getMoviesByGenreAndRefresh(mGenreList.first.id);
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    // /// Showcases
    // mMovieModel.getTopRatedMovies(1).then((movieList) {
    //   setState(() {
    //     mShowCaseMovieList = movieList;
    //   });
    // }).catchError((error) {
    //   debugPrint(error.toString());
    // });

    /// Showcases Database
    mMovieModel.getTopRatedMoviesFromDatabase().then((movieList) {
      setState(() {
        mShowCaseMovieList = movieList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Actors
    mMovieModel.getActors(1).then((actorList) {
      setState(() {
        mActors = actorList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });

    /// Actors Database
    mMovieModel.getAllActorsFromDatabase().then((actorList) {
      setState(() {
        mActors = actorList;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void _getMoviesByGenreAndRefresh(int genreId) {
    mMovieModel.getMoviesByGenre(genreId).then((moviesByGenre) {
      setState(() {
        mMoviesByGenreList = moviesByGenre;
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Text(
          MAIN_SCREEN_APP_BAR_TITLE,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Icon(
          Icons.menu,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 0,
              bottom: 0,
              right: MARGIN_MEDIUM_2,
            ),
            child: Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: Container(
        color: HOME_SCREEN_BACKGROUND_COLOR,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerSectionView(
                mPopularMovies: mPopularMoviesList?.take(8)?.toList() ?? [],
              ),
              SizedBox(height: MARGIN_LARGE),
              BestPopularMoviesAndSerialsSectionView(
                (movieId) => _navigateToMovieDetailsScreen(context, movieId),
                mNowPlayingMovieList,
              ),
              SizedBox(height: MARGIN_LARGE),
              CheckMovieShowTimesSectionView(),
              SizedBox(height: MARGIN_LARGE),
              GenreSectionView(
                genreList: mGenreList,
                onTapMovie: (movieId) =>
                    _navigateToMovieDetailsScreen(context, movieId),
                onTapGenre: (genreId) => _getMoviesByGenreAndRefresh(genreId),
                mMoviesByGenreList: mMoviesByGenreList,
              ),
              SizedBox(height: MARGIN_LARGE),
              ShowcasesSection(mShowCaseMovieList),
              SizedBox(height: MARGIN_LARGE),
              ActorsAndCreatorsSectionView(
                BEST_ACTORS_TITLE,
                BEST_ACTORS_SEE_MORE,
                mActorsList: mActors,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetailsScreen(BuildContext context, int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movieId),
      ),
    );
  }
}

class GenreSectionView extends StatelessWidget {
  final List<GenreVO> genreList;
  final List<MovieVO> mMoviesByGenreList;
  final Function(int) onTapMovie;
  final Function(int) onTapGenre;

  GenreSectionView({
    this.genreList,
    this.mMoviesByGenreList,
    this.onTapMovie,
    this.onTapGenre,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2,
          ),
          child: DefaultTabController(
            length: genreList?.length ?? 0,
            child: TabBar(
              onTap: (index) {
                this.onTapGenre(genreList[index].id);
              },
              isScrollable: true,
              indicatorColor: PLAY_BUTTON_COLOR,
              unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
              tabs: genreList
                  .map(
                    (genre) => Tab(
                      child: Text(genre.name),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Container(
          color: PRIMARY_COLOR,
          padding: EdgeInsets.only(
            top: MARGIN_MEDIUM_2,
            bottom: MARGIN_LARGE,
          ),
          child: HorizontalMovieListView(
            (movieId) {
              onTapMovie(movieId);
            },
            movieList: mMoviesByGenreList,
          ),
        ),
      ],
    );
  }
}

class CheckMovieShowTimesSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      margin: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      padding: EdgeInsets.all(MARGIN_LARGE),
      height: SHOWTIME_SECTION_HEIGHT,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MAIN_SCREEN_CHECK_MOVIE_SHOWTIMES,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_HEADING_1X,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              SeeMoreText(
                MAIN_SCREEN_SEE_MORE,
                textColor: PLAY_BUTTON_COLOR,
              )
            ],
          ),
          Spacer(),
          Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: BANNER_PLAY_BUTTON_SIZE,
          )
        ],
      ),
    );
  }
}

class ShowcasesSection extends StatelessWidget {
  final List<MovieVO> mShowCaseMovieList;

  ShowcasesSection(this.mShowCaseMovieList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: TitleTextWithSeeMoreView(
            SHOW_CASES_TITLE,
            SHOW_CASES_SEE_MORE,
          ),
        ),
        SizedBox(height: MARGIN_MEDIUM_2),
        Container(
          height: SHOW_CASES_HEIGHT,
          child: (mShowCaseMovieList != null)
              ? ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
                  children: mShowCaseMovieList
                      .map((showCaseMovie) => ShowCaseView(showCaseMovie))
                      .toList(),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}

class BestPopularMoviesAndSerialsSectionView extends StatelessWidget {
  final Function(int) onTapMovie;
  final List<MovieVO> mNowPlayingMovieList;

  BestPopularMoviesAndSerialsSectionView(
      this.onTapMovie, this.mNowPlayingMovieList);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: MARGIN_MEDIUM_2),
          child: TitleText(MAIN_SCREEN_BEST_POPULAR_MOVIES_AND_SERIALS),
        ),
        SizedBox(height: MARGIN_MEDIUM_2),
        HorizontalMovieListView(
          (movieId) {
            onTapMovie(movieId);
          },
          movieList: mNowPlayingMovieList,
        )
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final Function(int) onTapMovie;
  final List<MovieVO> movieList;

  HorizontalMovieListView(this.onTapMovie, {this.movieList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
              itemCount: movieList.length,
              itemBuilder: (BuildContext context, int index) {
                return MovieView(
                  (movieId) {
                    this.onTapMovie(movieId);
                  },
                  movieList[index],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO> mPopularMovies;

  BannerSectionView({this.mPopularMovies});

  @override
  _BannerSectionViewState createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.mPopularMovies.isNotEmpty)
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                child: PageView(
                    onPageChanged: (page) {
                      setState(() {
                        _position = page.toDouble();
                      });
                    },
                    children: widget.mPopularMovies
                        .map(
                          (popularMovie) => BannerView(
                            mMovie: popularMovie,
                          ),
                        )
                        .toList()),
              ),
              SizedBox(height: MARGIN_MEDIUM_2),
              DotsIndicator(
                dotsCount: widget.mPopularMovies.length ?? 1,
                position: _position,
                decorator: DotsDecorator(
                  color: HOME_SCREEN_BANNER_DOTS_INACTIVE_COLOR,
                  activeColor: PLAY_BUTTON_COLOR,
                ),
              )
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
