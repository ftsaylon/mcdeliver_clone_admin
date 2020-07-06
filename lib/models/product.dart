import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.categoryId,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromSnapshot(DataSnapshot snapshot) {
    return Product(
      id: snapshot.key,
      title: snapshot.value['title'],
      categoryId: snapshot.value['categoryId'],
      description: snapshot.value['description'],
      price: double.parse(snapshot.value['price'].toString()),
      imageUrl: snapshot.value['imageUrl'],
    );
  }

  Map toMap() {
    return {
      'title': title,
      'categoryId': categoryId,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
