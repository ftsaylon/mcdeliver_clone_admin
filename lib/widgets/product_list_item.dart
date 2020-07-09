import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/product.dart';
import 'package:mcdelivery_clone_admin/services/products_service.dart';

import 'product_form.dart';

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
        builder: (context) => ProductForm(
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
