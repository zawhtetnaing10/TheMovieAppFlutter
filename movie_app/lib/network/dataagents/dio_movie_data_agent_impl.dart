// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:movie_app/network/dataagents/movie_data_agent.dart';
//
// import '../api_constants.dart';
//
// class DioMovieDataAgentImpl extends MovieDataAgent {
//   @override
//   void getNowPlayingMovies(int page) {
//     Map<String, String> queryParameters = {
//       PARAM_API_KEY: API_KEY,
//       PARAM_LANGUAGE: LANGUAGE_EN_US,
//       PARAM_PAGE: page.toString()
//     };
//
//     Dio()
//         .get("$BASE_URL_DIO$ENDPOINT_GET_NOW_PLAYING",
//             queryParameters: queryParameters)
//         .then((value) {
//       debugPrint("Now Playing Movies ======> ${value.toString()}");
//     }).catchError((error) {
//       debugPrint("Error =========> ${error.toString()}");
//     });
//   }
// }
