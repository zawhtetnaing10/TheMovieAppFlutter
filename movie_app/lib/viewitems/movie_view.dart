import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/movie_vo.dart';
import 'package:movie_app/network/api_constants.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/widgets/rating_view.dart';

class MovieView extends StatelessWidget {
  final Function(int) onTapMovie;
  final MovieVO mMovie;

  MovieView(this.onTapMovie, this.mMovie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MARGIN_MEDIUM),
      width: MOVIE_LIST_ITEM_WIDTH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              onTapMovie(mMovie.id);
            },
            child: Image.network(
              "$IMAGE_BASE_URL${mMovie.posterPath}",
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Text(
            mMovie.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Row(
            children: [
              Text(
                "5.0",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: TEXT_REGULAR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: MARGIN_MEDIUM),
              RatingView(),
            ],
          )
        ],
      ),
    );
  }
}
