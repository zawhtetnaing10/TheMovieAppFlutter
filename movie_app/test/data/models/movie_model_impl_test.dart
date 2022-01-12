import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/data/vos/movie_vo.dart';

import '../../mock_data/mock_data.dart';
import '../../network/movie_data_agent_impl_mock.dart';
import '../../persistence/actor_dao_impl_mock.dart';
import '../../persistence/genre_dao_impl_mock.dart';
import '../../persistence/movie_dao_impl_mock.dart';

void main() {
  group("movie_model_impl", () {
    var movieModel = MovieModelImpl();

    setUp(() {
      movieModel.setDaosAndDataAgents(
        MovieDaoImplMock(),
        ActorDaoImplMock(),
        GenreDaoImplMock(),
        MovieDataAgentImplMock(),
      );
    });

    test(
        "Saving Now Playing Movies and Getting Now Playing Movies From Database",
        () {
      expect(
        movieModel.getNowPlayingMoviesFromDatabase(),
        emits(
          [
            MovieVO(
              false,
              "/t9nyF3r0WAlJ7Kr6xcRYI4jr9jm.jpg",
              [
                878,
                28,
              ],
              null,
              null,
              null,
              null,
              580489,
              null,
              "en",
              "Venom: Let There Be Carnage",
              "After finding a host body in investigative reporter Eddie Brock, the alien symbiote must face a new enemy, Carnage, the alter ego of serial killer Cletus Kasady.",
              10241.636,
              "/rjkmN1dniUHVYAtwuV3Tji7FsDO.jpg",
              null,
              null,
              null,
              null,
              "2021-09-30",
              null,
              null,
              null,
              "Venom: Let There Be Carnage",
              false,
              7.5,
              292,
              isNowPlaying: true,
              isPopular: false,
              isTopRated: false,
            ),
          ],
        ),
      );
    });

    test("Saving Popular Movies and Getting Popular Movies From Database", () {
      expect(
          movieModel.getPopularMoviesFromDatabase(),
          emits(
            [
              MovieVO(
                  false,
                  "/8Y43POKjjKDGI9MH89NW0NAzzp8.jpg",
                  [
                    35,
                    28,
                    12,
                    878,
                  ],
                  null,
                  null,
                  null,
                  null,
                  550988,
                  null,
                  "en",
                  "Free Guy",
                  "A bank teller called Guy realizes he is a background character in an open world video game called Free City that will soon go offline.",
                  7639.202,
                  "/xmbU4JTUm8rsdtn7Y3Fcm30GpeT.jpg",
                  null,
                  null,
                  null,
                  null,
                  "2021-08-11",
                  null,
                  null,
                  null,
                  "Free Guy",
                  false,
                  7.9,
                  2340,
                  isPopular: true,
                  isTopRated: false,
                  isNowPlaying: false),
            ],
          ));
    });

    test("Saving Top Rated Movies and Getting Now Playing Movies From Database",
        () {
      expect(
          movieModel.getTopRatedMoviesFromDatabase(),
          emits(
            [
              MovieVO(
                false,
                "/aO9Nnv9GdwiPdkNO79TISlQ5bbG.jpg",
                [
                  28,
                  12,
                ],
                null,
                null,
                null,
                null,
                568620,
                null,
                "en",
                "Snake Eyes: G.I. Joe Origins",
                "After saving the life of their heir apparent, tenacious loner Snake Eyes is welcomed into an ancient Japanese clan called the Arashikage where he is taught the ways of the ninja warrior. But, when secrets from his past are revealed, Snake Eyes' honor and allegiance will be tested – even if that means losing the trust of those closest to him.",
                3530.788,
                "/uIXF0sQGXOxQhbaEaKOi2VYlIL0.jpg",
                null,
                null,
                null,
                null,
                "2021-07-22",
                null,
                null,
                null,
                "Snake Eyes: G.I. Joe Origins",
                false,
                6.9,
                595,
                isTopRated: true,
                isNowPlaying: false,
                isPopular: false,
              ),
            ],
          ));
    });

    test("Get Genres Test", () {
      expect(
          movieModel.getGenres(),
          completion(
            equals(getMockGenres()),
          ));
    });

    test("Get Actors Test", () {
      expect(
          movieModel.getActors(1),
          completion(
            equals(getMockActors()),
          ));
    });

    test("Get Credits Test", () {
      expect(
          movieModel.getCreditsByMovie(1),
          completion(
            equals(getMockCredits()),
          ));
    });

    test("Get Movie Details Test", () {
      expect(
          movieModel.getMovieDetails(1),
          completion(
            equals(getMockMoviesForTest().first),
          ));
    });

    test("Get Actors From Database Test", () async {
      await movieModel.getActors(1);
      expect(
          movieModel.getAllActorsFromDatabase(),
          completion(
            equals(getMockActors()),
          ));
    });

    test("Get Movie Details From Database Test", () async {
      await movieModel.getMovieDetails(1);
      expect(
          movieModel.getMovieDetails(1),
          completion(
            equals(getMockMoviesForTest().first),
          ));
    });

    test("Get Genres From Database Test", () async {
      await movieModel.getGenres();
      expect(
          movieModel.getGenresFromDatabase(),
          completion(
            equals(getMockGenres()),
          ));
    });
  });
}
