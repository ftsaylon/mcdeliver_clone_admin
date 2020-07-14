import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../models/category.dart';
import '../models/product.dart';

import '../screens/product_form_screen.dart';
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

  StreamSubscription<Event> _onChildAdded;
  StreamSubscription<Event> _onChildRemoved;
  StreamSubscription<Event> _onChildChanged;

  @override
  void initState() {
    _onChildAdded =
        _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _onChildRemoved = _database
        .reference()
        .child(nodeName)
        .onChildRemoved
        .listen(_childRemoves);
    _onChildChanged = _database
        .reference()
        .child(nodeName)
        .onChildChanged
        .listen(_childChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onChildAdded.cancel();
    _onChildRemoved.cancel();
    _onChildChanged.cancel();
    super.dispose();
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      '${widget.category.title}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('ADD PRODUCT'),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductFormScreen(
                            categoryId: widget.category.id,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: productsList.isNotEmpty,
              child: Expanded(
                child: FirebaseAnimatedList(
                  query: _database
                      .reference()
                      .child('products')
                      .orderByChild('categoryId')
                      .equalTo(widget.category.id),
                  itemBuilder: (context, snapshot, animation, index) {
                    if (index < productsList.length) {
                      final product = productsList[index];
                      return ProductListItem(
                        key: UniqueKey(),
                        product: product,
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _childAdded(Event event) {
    if (event.snapshot.value['categoryId'] == widget.category.id) {
      setState(() {
        productsList.add(Product.fromSnapshot(event.snapshot));
      });
    }
  }

  void _childRemoves(Event event) {
    var deletedProduct = productsList.singleWhere((product) {
      return product.id == event.snapshot.key;
    });

    setState(() {
      productsList.removeAt(productsList.indexOf(deletedProduct));
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
