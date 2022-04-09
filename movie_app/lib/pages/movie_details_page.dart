import 'package:flutter/material.dart';
import 'package:movie_app/blocs/movie_details_bloc.dart';
import 'package:movie_app/data/vos/credit_vo.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/resources/strings.dart';
import 'package:movie_app/widgets/actors_and_creators_section_view.dart';
import 'package:movie_app/widgets/gradient_view.dart';
import 'package:movie_app/widgets/rating_view.dart';
import 'package:movie_app/widgets/title_text.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  MovieDetailsPage(this.movieId);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late MovieDetailsBloc _bloc;

  @override
  void initState() {
    _bloc = MovieDetailsBloc(widget.movieId);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.disposeStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.movieStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot<MovieVO?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Container(
              color: HOME_SCREEN_BACKGROUND_COLOR,
              child: CustomScrollView(
                slivers: [
                  MovieDetailsSliverAppBarView(
                    () => Navigator.pop(context),
                    snapshot.data!,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2,
                          ),
                          child: TrailerSection(snapshot.data!),
                        ),
                        SizedBox(height: MARGIN_LARGE),
                        StreamBuilder(
                          stream: _bloc.actorsStreamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CreditVO>?> snapshot) {
                            return (snapshot.hasData &&
                                    (snapshot.data?.isNotEmpty ?? false))
                                ? ActorsAndCreatorsSectionView(
                                    MOVIE_DETAILS_SCREEN_ACTORS_TITLE,
                                    "",
                                    seeMoreButtonVisibility: false,
                                    mActorsList: snapshot.data,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        ),
                        SizedBox(height: MARGIN_LARGE),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2,
                          ),
                          child: AboutFilmSectionView(snapshot.data!),
                        ),
                        SizedBox(height: MARGIN_LARGE),
                        StreamBuilder(
                          stream: _bloc.creatorsStreamController.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CreditVO>?> snapshot) {
                            if (snapshot.hasData &&
                                (snapshot.data?.isNotEmpty ?? false)) {
                              return ActorsAndCreatorsSectionView(
                                MOVIE_DETAILS_SCREEN_CREATORS_TITLE,
                                MOVIE_DETAILS_SCREEN_CREATORS_SEE_MORE,
                                mActorsList: snapshot.data,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class AboutFilmSectionView extends StatelessWidget {
  final MovieVO? mMovie;

  AboutFilmSectionView(this.mMovie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText("ABOUT FILM"),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Original Title:",
          mMovie?.originalTitle ?? "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Type:",
          mMovie?.genres?.map((genre) => genre.name).join(",") ?? "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Production:",
          mMovie?.productionCountries
                  ?.map((country) => country.name)
                  .join(",") ??
              "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Premiere:",
          mMovie?.releaseDate ?? "",
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        AboutFilmInfoView(
          "Description:",
          mMovie?.overview ?? "",
        ),
      ],
    );
  }
}

class AboutFilmInfoView extends StatelessWidget {
  final String label;
  final String description;

  AboutFilmInfoView(this.label, this.description);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Text(
            label,
            style: TextStyle(
              color: MOVIE_DETAIL_INFO_TEXT_COLOR,
              fontSize: MARGIN_MEDIUM_2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: MARGIN_CARD_MEDIUM_2),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white,
              fontSize: MARGIN_MEDIUM_2,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}

class TrailerSection extends StatelessWidget {
  final MovieVO mMovie;

  TrailerSection(this.mMovie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieTimeAndGenreView(
          genreList:
              mMovie?.genres?.map((genre) => genre.name ?? "")?.toList() ?? [],
        ),
        SizedBox(
          height: MARGIN_MEDIUM_3,
        ),
        StoryLineView(mMovie?.overview ?? ""),
        SizedBox(height: MARGIN_MEDIUM_2),
        Row(
          children: [
            MovieDetailsScreenButtonView(
              "PLAY TRAILER",
              PLAY_BUTTON_COLOR,
              Icon(
                Icons.play_circle_filled,
                color: Colors.black54,
              ),
            ),
            SizedBox(width: MARGIN_CARD_MEDIUM_2),
            MovieDetailsScreenButtonView(
              "RATE MOVIE",
              HOME_SCREEN_BACKGROUND_COLOR,
              Icon(
                Icons.star,
                color: PLAY_BUTTON_COLOR,
              ),
              isGhostButton: true,
            ),
          ],
        )
      ],
    );
  }
}

class MovieDetailsScreenButtonView extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Icon buttonIcon;
  final bool isGhostButton;

  MovieDetailsScreenButtonView(
    this.title,
    this.backgroundColor,
    this.buttonIcon, {
    this.isGhostButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM_2),
      height: MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          MARGIN_LARGE,
        ),
        border: (isGhostButton)
            ? Border.all(
                color: Colors.white,
                width: 2,
              )
            : null,
      ),
      child: Center(
        child: Row(
          children: [
            buttonIcon,
            SizedBox(width: MARGIN_MEDIUM),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: TEXT_REGULAR_2X,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryLineView extends StatelessWidget {
  final String storyLine;

  StoryLineView(this.storyLine);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(MOVIE_DETAILS_STORYLINE_TITLE),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        Text(
          this.storyLine,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
          ),
        )
      ],
    );
  }
}

class MovieTimeAndGenreView extends StatelessWidget {
  const MovieTimeAndGenreView({
    required this.genreList,
  });

  final List<String>? genreList;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: _createMovieTimeAndGenreWidget(),
    );
  }

  List<Widget> _createMovieTimeAndGenreWidget() {
    List<Widget> widgets = [
      Icon(
        Icons.access_time,
        color: PLAY_BUTTON_COLOR,
      ),
      SizedBox(width: MARGIN_SMALL),
      Container(
        child: Text(
          "2h 30min",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(width: MARGIN_MEDIUM),
    ];

    widgets.addAll(
        genreList?.map((genre) => GenreChipView(genre ?? "")).toList() ?? []);

    widgets.add(
      Icon(
        Icons.favorite_border,
        color: Colors.white,
      ),
    );
    return widgets;
  }
}

class GenreChipView extends StatelessWidget {
  final String genreText;

  GenreChipView(this.genreText);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          backgroundColor: MOVIE_DETAILS_SCREEN_CHIP_BACKGROUND_COLOR,
          label: Text(
            genreText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_SMALL,
        ),
      ],
    );
  }
}

class MovieDetailsSliverAppBarView extends StatelessWidget {
  final Function onTapBack;

  final MovieVO? mMovie;

  MovieDetailsSliverAppBarView(this.onTapBack, this.mMovie);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: false,
      expandedHeight: MOVIE_DETAILS_SCREEN_SLIVER_APP_BAR_HEIGHT,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              children: [
                Positioned.fill(
                  child: MovieDetailsAppBarImageView(mMovie?.posterPath ?? ""),
                ),
                Positioned.fill(
                  child: GradientView(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MARGIN_XXLARGE,
                      left: MARGIN_MEDIUM_2,
                    ),
                    child: BackButtonView(
                      () => onTapBack(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MARGIN_XXLARGE + MARGIN_MEDIUM,
                      right: MARGIN_MEDIUM_2,
                    ),
                    child: SearchButtonView(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MARGIN_MEDIUM_2,
                      right: MARGIN_MEDIUM_2,
                      bottom: MARGIN_LARGE,
                    ),
                    child: (mMovie != null)
                        ? MovieDetailsAppBarInfoView(mMovie!)
                        : Container(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieDetailsAppBarInfoView extends StatelessWidget {
  final MovieVO? mMovie;

  MovieDetailsAppBarInfoView(this.mMovie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            MovieDetailsYearView(mMovie?.releaseDate?.substring(0, 4) ?? ""),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingView(),
                    SizedBox(
                      height: MARGIN_SMALL,
                    ),
                    TitleText("${mMovie?.voteCount} VOTES"),
                    SizedBox(
                      height: MARGIN_CARD_MEDIUM_2,
                    ),
                  ],
                ),
                SizedBox(width: MARGIN_MEDIUM),
                Text(
                  "${mMovie?.voteAverage}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MOVIE_DETAILS_RATING_TEXT_SIZE,
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: MARGIN_MEDIUM),
        Text(
          mMovie?.title ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_HEADING_2X,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MovieDetailsYearView extends StatelessWidget {
  final String year;

  MovieDetailsYearView(this.year);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      height: MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: PLAY_BUTTON_COLOR,
        borderRadius: BorderRadius.circular(
          MARGIN_LARGE,
        ),
      ),
      child: Center(
        child: Text(
          year,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SearchButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.search,
      color: Colors.white,
      size: MARGIN_XLARGE,
    );
  }
}

class BackButtonView extends StatelessWidget {
  final Function onTapBack;

  BackButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTapBack();
      },
      child: Container(
        width: MARGIN_XXLARGE,
        height: MARGIN_XXLARGE,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Icon(
          Icons.chevron_left,
          color: Colors.white,
          size: MARGIN_XLARGE,
        ),
      ),
    );
  }
}

class MovieDetailsAppBarImageView extends StatelessWidget {
  final String movieImage;

  MovieDetailsAppBarImageView(this.movieImage);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$IMAGE_BASE_URL$movieImage",
      fit: BoxFit.cover,
    );
  }
}
