import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/blocs/home_bloc.dart';
import 'package:movie_app/data/vos/actor_vo.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/pages/movie_details_page.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/viewitems/banner_view.dart';
import 'package:movie_app/viewitems/showcase_view.dart';
import 'package:movie_app/widgets/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/see_more_text.dart';
import 'package:movie_app/widgets/title_and_horizontal_movie_list_view.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
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
                Selector<HomeBloc, List<MovieVO>?>(
                  selector: (context, bloc) => bloc.mPopularMoviesList,
                  builder: (context, popularMovieList, child) =>
                      BannerSectionView(
                    mPopularMovies: popularMovieList?.take(8).toList(),
                  ),
                ),
                SizedBox(height: MARGIN_LARGE),
                Selector<HomeBloc, List<MovieVO>?>(
                  selector: (context, bloc) => bloc.mNowPlayingMovieList,
                  builder: (context, nowPlayingMovieList, child) =>
                      TitleAndHorizontalMovieListView(
                    (movieId) =>
                        _navigateToMovieDetailsScreen(context, movieId),
                    nowPlayingMovieList,
                    title: MAIN_SCREEN_BEST_POPULAR_MOVIES_AND_SERIALS,
                    onListEndReached: () {
                      var bloc = Provider.of<HomeBloc>(context, listen: false);
                      bloc.onNowPlayingMovieListEndReached();
                    },
                  ),
                ),
                SizedBox(height: MARGIN_LARGE),
                CheckMovieShowTimesSectionView(),
                SizedBox(height: MARGIN_LARGE),
                Selector<HomeBloc, List<GenreVO>?>(
                  selector: (context, bloc) => bloc.mGenreList,
                  builder: (context, genreList, child) =>
                      Selector<HomeBloc, List<MovieVO>?>(
                    selector: (context, bloc) => bloc.mMoviesByGenreList,
                    builder: (context, moviesByGenreList, child) =>
                        GenreSectionView(
                      genreList: genreList,
                      onTapMovie: (movieId) =>
                          _navigateToMovieDetailsScreen(context, movieId),
                      onTapGenre: (genreId) {
                        HomeBloc bloc =
                            Provider.of<HomeBloc>(context, listen: false);
                        bloc.onTapGenre(genreId);
                      },
                      mMoviesByGenreList: moviesByGenreList,
                    ),
                  ),
                ),
                SizedBox(height: MARGIN_LARGE),
                Selector<HomeBloc, List<MovieVO>?>(
                  selector: (context, bloc) => bloc.mShowCaseMovieList,
                  builder: (context, showCaseMovieList, child) =>
                      ShowcasesSection(showCaseMovieList),
                ),
                SizedBox(height: MARGIN_LARGE),
                Selector<HomeBloc, List<ActorVO>?>(
                  selector: (context, bloc) => bloc.mActors,
                  builder: (context, actors, child) =>
                      ActorsAndCreatorsSectionView(
                    BEST_ACTORS_TITLE,
                    BEST_ACTORS_SEE_MORE,
                    mActorsList: actors,
                  ),
                ),
              ],
            ),
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
  final List<GenreVO>? genreList;
  final List<MovieVO>? mMoviesByGenreList;
  final Function(int) onTapMovie;
  final Function(int) onTapGenre;

  GenreSectionView({
    this.genreList,
    this.mMoviesByGenreList,
    required this.onTapMovie,
    required this.onTapGenre,
  });

  @override
  Widget build(BuildContext context) {
    return (genreList == null || (genreList?.isEmpty ?? true))
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MARGIN_MEDIUM_2,
                ),
                child: DefaultTabController(
                  length: genreList?.length ?? 0,
                  child: TabBar(
                    onTap: (index) {
                      this.onTapGenre(genreList?[index].id ?? 0);
                    },
                    isScrollable: true,
                    indicatorColor: PLAY_BUTTON_COLOR,
                    unselectedLabelColor: HOME_SCREEN_LIST_TITLE_COLOR,
                    tabs: genreList
                            ?.map(
                              (genre) => Tab(
                                child: Text(genre.name),
                              ),
                            )
                            .toList() ??
                        [],
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
                  onListEndReached: () {
                    //
                  },
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
  final List<MovieVO>? mShowCaseMovieList;

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
                          ?.map((showCaseMovie) => ShowCaseView(showCaseMovie))
                          .toList() ??
                      [],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ],
    );
  }
}

class BannerSectionView extends StatefulWidget {
  final List<MovieVO>? mPopularMovies;

  BannerSectionView({this.mPopularMovies});

  @override
  _BannerSectionViewState createState() => _BannerSectionViewState();
}

class _BannerSectionViewState extends State<BannerSectionView> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.mPopularMovies?.isNotEmpty ?? false)
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
                            ?.map(
                              (popularMovie) => BannerView(
                                mMovie: popularMovie,
                              ),
                            )
                            .toList() ??
                        []),
              ),
              SizedBox(height: MARGIN_MEDIUM_2),
              DotsIndicator(
                dotsCount: widget.mPopularMovies?.length ?? 1,
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
