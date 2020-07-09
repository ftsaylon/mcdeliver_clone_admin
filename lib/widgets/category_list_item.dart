import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';
import 'package:mcdelivery_clone_admin/screens/products_list_screen.dart';
import 'package:mcdelivery_clone_admin/services/categories_service.dart';

import 'category_form.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final void Function() removeFn;

  const CategoryListItem({
    Key key,
    this.category,
    this.removeFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriesService = CategoriesService(category: category);
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsListScreen(
              category: category,
            ),
          ),
        );
      },
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          category.title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showAddCategory(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteCategory(context, categoriesService);
            },
          ),
        ],
      ),
    );
  }

  void _showAddCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategoryForm(
          category: category,
        );
      },
    );
  }

  void _showDeleteCategory(
    BuildContext context,
    CategoriesService categoriesService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('All products in this Category will also be deleted.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              categoriesService.deleteCategory();
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
        ],
      ),
    );
  }
}
