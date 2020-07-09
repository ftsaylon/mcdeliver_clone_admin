import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';

import '../models/product.dart';

import '../widgets/product_form.dart';
import '../services/products_service.dart';

import '../widgets/product_list_item.dart';

class ProductsListScreen extends StatefulWidget {
  static const routeName = '/products';

  final Category category;

  ProductsListScreen({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/logo/simple_logo.png',
              height: MediaQuery.of(context).size.width * 0.15,
            ),
            Text('McDelivery'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
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
                      // _showAddProduct(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductForm(
                            categoryId: widget.category.id,
                          ),
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
                      query: _database
                          .reference()
                          .child('products')
                          .orderByChild('categoryId')
                          .equalTo(widget.category.id),
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

  // void _showAddProduct(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return ProductForm(
  //         categoryId: widget.category.id,
  //       );
  //     },
  //   );
  // }
}
