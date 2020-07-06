import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      url =
          'https://mcdelivery-clone-customer-app.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            categoryId: prodData['categoryId'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> getProductsByCategory(String categoryId) {
    return [..._items.where((product) => product.categoryId == categoryId)];
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'categoryId': product.categoryId,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          // 'creatorId': userId,
        }),
      );
      print(response.body);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        categoryId: product.categoryId,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final productIndex = _items.indexWhere((product) => product.id == id);
    _items.removeAt(productIndex);
    notifyListeners();
  }

  void toggleFavoriteStatus(String authToken, String userId, String productId) {
    findById(productId).toggleFavoriteStatus(authToken, userId);
    notifyListeners();
  }
}
