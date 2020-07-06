import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'package:mcdelivery_clone_admin/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  User _user;

  User get user {
    return _user;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<String> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyDaCmfnpptGQfHjuDADo2TjozR4qNQZRF8';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
      return _userId;
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    final userId = await _authenticate(email, password, 'signupNewUser');
    _user = User(
      id: '',
      userId: userId,
      firstName: '',
      lastName: '',
      email: email,
      address: '',
    );
    createUser(_user);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final userId = await _authenticate(email, password, 'verifyPassword');
    fetchAndSetUser(userId);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    fetchAndSetUser(_userId);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> createUser(User user) async {
    final url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/users.json?auth=$_token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'userId': user.userId,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'address': user.address,
          },
        ),
      );
      final newUser = User(
        id: json.decode(response.body)['name'],
        userId: user.userId,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        address: user.address,
      );
      _user = newUser;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateUser(String id, User user) async {
    final url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/users/$id.json?auth=$_token';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'userId': user.userId,
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'address': user.address,
          },
        ),
      );
      final newUser = User(
        id: json.decode(response.body)['name'],
        userId: user.userId,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        address: user.address,
      );
      _user = newUser;
      print(_user.firstName);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetUser(String userId) async {
    final filterString = 'orderBy="userId"&equalTo="$userId"';
    var url =
        'https://mcdelivery-clone-customer-app.firebaseio.com/users.json?auth=$_token&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach(
        (id, userData) {
          _user = User(
            id: id,
            userId: userData['userId'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
            email: userData['email'],
            address: userData['address'],
          );
        },
      );
      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
