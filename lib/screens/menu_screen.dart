import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../models/category.dart';

import '../widgets/category_form.dart';
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

  StreamSubscription _onChildAdded;
  StreamSubscription _onChildRemoved;
  StreamSubscription _onChildChanged;

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
          Visibility(
            visible: categoriesList.isNotEmpty,
            child: Expanded(
              child: FirebaseAnimatedList(
                query: _database.reference().child('categories'),
                itemBuilder: (context, snapshot, animation, index) {
                  if (index < categoriesList.length) {
                    final category = categoriesList[index];
                    return CategoryListItem(
                      key: UniqueKey(),
                      category: category,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
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
