import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/product.dart';
import 'package:mcdelivery_clone_admin/screens/edit_product_screen.dart';
import 'package:mcdelivery_clone_admin/services/products_service.dart';
import 'package:mcdelivery_clone_admin/widgets/app_drawer.dart';
import 'package:mcdelivery_clone_admin/widgets/product_list_item.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

  ProductsScreen({Key key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductScreen(),
            ),
          );
        },
      ),
    );
  }

  _childAdded(Event event) {
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
