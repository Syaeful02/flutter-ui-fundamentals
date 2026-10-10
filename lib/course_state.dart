// 2415051059 - Syaeful Darmawan
//
// `CourseState` adalah `ChangeNotifier` yang menyimpan state favorites.
// State + method perubahan state dipisahkan dari widget (State) supaya
// bisa dipakai oleh banyak screen tanpa prop drilling.

import 'package:flutter/foundation.dart';

class CourseState extends ChangeNotifier {
  // State disimpan private, hanya bisa diubah lewat method publik.
  final Set<String> _favorites = {};

  // ---------- GETTER (read-only untuk UI) ----------
  Set<String> get favorites => _favorites;

  int get favoriteCount => _favorites.length;

  bool isFavorite(String code) => _favorites.contains(code);

  // ---------- METHOD (mutasi state + notifikasi) ----------
  void toggleFavorite(String code) {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    // Panggil notifyListeners() SETELAH state berubah,
    // supaya semua widget yang listen mendapat nilai terbaru.
    notifyListeners();
  }

  void clearFavorites() {
    if (_favorites.isEmpty) return;
    _favorites.clear();
    notifyListeners();
  }
}
