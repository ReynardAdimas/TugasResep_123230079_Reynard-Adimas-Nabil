import 'package:hive/hive.dart';
import '../models/resep_hive.dart';

class FavoriteService {
  static Box<ResepHive> get _box => Hive.box<ResepHive>('favorites');

  static Future<void> addFavorite(ResepHive resep) async {
    await _box.put(resep.id, resep);
  }

  static Future<void> removeFavorite(String id) async {
    await _box.delete(id);
  }

  static List<ResepHive> getFavorites() {
    return _box.values.toList();
  }

  static bool isfavorite(String id) {
    return _box.containsKey(id);
  }
}