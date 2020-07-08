import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../models/product.dart';

import 'edit_product_screen.dart';
import '../services/products_service.dart';

import '../widgets/product_list_item.dart';

class ProductsList extends StatefulWidget {
  static const routeName = '/products';

  final String categoryId;

  ProductsList({
    Key key,
    this.categoryId,
  }) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = 'products';
  List<Product> productsList = <Product>[];

  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: Text('ADD PRODUCT'),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Visibility(
                visible: productsList.isNotEmpty,
                child: Expanded(
                  child: FirebaseAnimatedList(
                    query: _database.reference().child('products'),
                    itemBuilder: (context, snapshot, animation, index) {
                      final product = productsList[index];
                      return ProductListItem(
                        product: product,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _childAdded(Event event) {
    setState(() {
      productsList.add(Product.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedproduct = productsList.singleWhere((product) {
      return product.id == event.snapshot.key;
    });

    setState(() {
      productsList.removeAt(productsList.indexOf(deletedproduct));
    });
  }

  void _childChanged(Event event) {
    var changedproduct = productsList.singleWhere((product) {
      return product.id == event.snapshot.key;
    });

    setState(() {
      productsList[productsList.indexOf(changedproduct)] =
          Product.fromSnapshot(event.snapshot);
    });
  }
}
