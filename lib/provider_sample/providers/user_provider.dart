import 'package:flutter/foundation.dart';

import '../../shared/models/user.dart';

class UserProvider with ChangeNotifier {
  User _currentUser;
  User get currentUser => _currentUser;
  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  List<User> _users = [];
  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    _currentUser = user;
    notifyListeners();
  }
}
