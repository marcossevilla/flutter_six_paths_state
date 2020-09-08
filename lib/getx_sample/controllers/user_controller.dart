import 'package:get/get.dart';

import '../../shared/models/user.dart';

class UserController extends GetxController {
  var current = User().obs;
  var accounts = <User>[].obs;

  void setCurrent(User value) => current.value = value;

  void addUser(User value) {
    accounts.add(value);
    current.value = value;
  }
}
