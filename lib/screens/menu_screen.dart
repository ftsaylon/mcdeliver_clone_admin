import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';
import 'package:mcdelivery_clone_admin/widgets/category_form.dart';

import '../widgets/category_list_item.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu';

  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = 'categories';
  List<Category> categoriesList = [];

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
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RaisedButton(
                  child: Text('ADD CATEGORY'),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    _showAddCategory(context);
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
                visible: categoriesList.isNotEmpty,
                child: Expanded(
                  child: FirebaseAnimatedList(
                    query: _database.reference().child('categories'),
                    itemBuilder: (context, snapshot, animation, index) {
                      final category = categoriesList[index];
                      return CategoryListItem(
                        category: category,
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
      categoriesList.add(Category.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedCategory = categoriesList.singleWhere((category) {
      return category.id == event.snapshot.key;
    });

    setState(() {
      categoriesList.removeAt(categoriesList.indexOf(deletedCategory));
    });
  }

  void _childChanged(Event event) {
    var changedCategory = categoriesList.singleWhere((category) {
      return category.id == event.snapshot.key;
    });

    setState(() {
      categoriesList[categoriesList.indexOf(changedCategory)] =
          Category.fromSnapshot(event.snapshot);
    });
  }

  void _showAddCategory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategoryForm();
      },
    );
  }
}
