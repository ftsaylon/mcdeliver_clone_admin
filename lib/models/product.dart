import 'package:firebase_database/firebase_database.dart';

class Product {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    this.id,
    this.title,
    this.categoryId,
    this.description,
    this.price,
    this.imageUrl,
  });

  factory Product.fromSnapshot(DataSnapshot snapshot) {
    print('${snapshot.value['categoryId']} ${snapshot.value['title']}');
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
