import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';
import 'package:mcdelivery_clone_admin/screens/products_list_screen.dart';

class CategoryTab extends StatelessWidget {
  final Category category;

  const CategoryTab({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: ProductsListScreen(
        category: category,
      ),
    );
  }
}
