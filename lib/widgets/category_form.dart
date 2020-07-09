import 'package:flutter/material.dart';
import 'package:mcdelivery_clone_admin/models/category.dart';
import 'package:mcdelivery_clone_admin/services/categories_service.dart';

class CategoryForm extends StatefulWidget {
  final Category category;

  static const routeName = '/edit-product';

  CategoryForm({
    Key key,
    this.category,
  }) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _titleFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedCategory = Category(
    id: null,
    title: '',
  );

  var _initValues = {
    'title': '',
  };

  var _isLoading = false;

  @override
  void initState() {
    if (widget.category != null) {
      _editedCategory = widget.category;
      _initValues = {
        'title': _editedCategory.title,
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    final categoriesService = CategoriesService(category: _editedCategory);

    setState(() {
      _isLoading = true;
    });
    if (_editedCategory.id != null) {
      await categoriesService.updateCategory();
    } else {
      try {
        await categoriesService.addCategory();
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    (widget.category != null)
                        ? 'EDIT CATEGORY'
                        : 'NEW CATEGORY',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: _form,
                    child: TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCategory = Category(
                          id: _editedCategory.id,
                          title: value,
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      onPressed: _saveForm,
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
