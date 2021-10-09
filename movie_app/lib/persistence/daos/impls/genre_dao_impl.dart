import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/persistence/hive_constants.dart';

class GenreDaoImpl {
  static final GenreDaoImpl _singleton = GenreDaoImpl._internal();

  factory GenreDaoImpl() {
    return _singleton;
  }

  GenreDaoImpl._internal();

  void saveAllGenres(List<GenreVO> genreList) async {
    Map<int, GenreVO> actorMap = Map.fromIterable(genreList,
        key: (genre) => genre.id, value: (genre) => genre);
    await getGenreBox().putAll(actorMap);
  }

  List<GenreVO> getAllGenres() {
    return getGenreBox().values.toList();
  }

  Box<GenreVO> getGenreBox() {
    return Hive.box<GenreVO>(BOX_NAME_GENRE_VO);
  }
}
