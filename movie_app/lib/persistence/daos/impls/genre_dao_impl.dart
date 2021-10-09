import 'package:hive/hive.dart';
import 'package:movie_app/data/vos/genre_vo.dart';
import 'package:movie_app/persistence/daos/genre_dao.dart';
import 'package:movie_app/persistence/hive_constants.dart';

class GenreDaoImpl extends GenreDao {
  static final GenreDaoImpl _singleton = GenreDaoImpl._internal();

  factory GenreDaoImpl() {
    return _singleton;
  }

  GenreDaoImpl._internal();

  @override
  void saveAllGenres(List<GenreVO> genreList) async {
    Map<int, GenreVO> actorMap = Map.fromIterable(genreList,
        key: (genre) => genre.id, value: (genre) => genre);
    await getGenreBox().putAll(actorMap);
  }

  @override
  List<GenreVO> getAllGenres() {
    return getGenreBox().values.toList();
  }

  Box<GenreVO> getGenreBox() {
    return Hive.box<GenreVO>(BOX_NAME_GENRE_VO);
  }
}
