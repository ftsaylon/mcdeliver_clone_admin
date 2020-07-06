import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/product.dart';

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    );
  }
}
