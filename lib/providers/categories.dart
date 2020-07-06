import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [];

  String authToken;

  Categories(this.authToken, this._items);

  List<Category> get items {
    return [..._items];
  }

  Category findById(String id) {
    return _items.firstWhere((category) => category.id == id);
  }

  Future<void> fetchAndSetCategories() async {
    var url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/categories.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Category> loadedCategories = [];
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(
          Category(
            id: categoryId,
            title: categoryData['title'],
          ),
        );
      });
      _items = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCategory(Category category) async {
    final url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/categories.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': category.title,
          // 'creatorId': userId,
        }),
      );
      print(response.body);
      final newCategory = Category(
        id: json.decode(response.body)['name'],
        title: category.title,
      );
      _items.add(newCategory);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
