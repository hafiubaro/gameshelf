import 'package:flutter/foundation.dart';

// Favorit disimpan selama sesi aplikasi, belum menggunakan penyimpanan permanen.
class FavoritesStore extends ChangeNotifier {
  final Set<String> _ids = {};
  bool contains(String id) => _ids.contains(id);
  void toggle(String id) {
    if (!_ids.add(id)) _ids.remove(id);
    notifyListeners();
  }
}
