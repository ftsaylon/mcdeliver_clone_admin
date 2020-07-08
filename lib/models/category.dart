import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Category {
  String id;
  String title;

  Category({
    @required this.id,
    @required this.title,
  });

  factory Category.fromSnapshot(DataSnapshot snapshot) {
    return Category(
      id: snapshot.key,
      title: snapshot.value['title'],
    );
  }

  Map toMap() {
    return {
      'title': title,
    };
  }
}
