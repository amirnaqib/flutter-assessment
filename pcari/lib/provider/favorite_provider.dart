import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _fav = [];
  List<String> get fav => _fav;

  void toggleFavorite(String fav) {
    final isExist = _fav.contains(fav);
    if (isExist) {
      _fav.remove(fav);
    } else {
      _fav.add(fav);
    }
    print(_fav.toString());

    notifyListeners();
  }

  bool isExist(String fav) {
    final isExist = _fav.contains(fav);
    return isExist;
  }

  void clearFavorite() {
    _fav = [];
    notifyListeners();
  }
}
