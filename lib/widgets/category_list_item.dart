import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';
import 'package:mcdelivery_clone_admin/models/product.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;

  const CategoryListItem({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(
        category.title,
        style: TextStyle(
          fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
