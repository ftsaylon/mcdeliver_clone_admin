import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/products_service.dart';

import '../screens/product_form_screen.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsService = ProductsService(product: product);

    return ListTile(
      onTap: () {},
      isThreeLine: true,
      leading: Image.network(product.imageUrl),
      title: Text(
        product.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('\$${product.price}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showAddProduct(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteProduct(context, productsService);
            },
          ),
        ],
      ),
    );
  }

  void _showAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(
          product: product,
          categoryId: product.categoryId,
        ),
      ),
    );
  }

  void _showDeleteProduct(
    BuildContext context,
    ProductsService productsService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('You are deleting ${product.title}'),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              productsService.deleteProduct();
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
