import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  int get count => _favorites.length;

  bool isFavorite(String productId) {
    return _favorites.any((product) => product.id == productId);
  }

  void toggleFavorite(Product product) {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFromFavorites(String productId) {
    _favorites.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
