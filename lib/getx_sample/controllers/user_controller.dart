import 'package:get/get.dart';
import 'package:six_paths_core/six_paths_core.dart';

class UserController extends GetxController {
  var current = User(email: 'no-email', name: 'no-user').obs;
  var accounts = <User>[].obs;

  void setCurrent(User value) => current.value = value;

  void addUser(User value) {
    accounts.add(value);
    current.value = value;
  }
}
