import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/screens/products_list.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({Key key, this.categoryId}) : super(key: key);

  final categoryId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: ProductsList(
        categoryId: categoryId,
      ),
    );
  }
}
