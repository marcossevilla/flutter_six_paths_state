import 'package:get/get.dart';
import 'package:six_paths_core/six_paths_core.dart';

class UserController extends GetxController {
  final current = User(email: 'no-email', name: 'no-user').obs;
  final accounts = <User>[].obs;

  // ignore: use_setters_to_change_properties
  void changeCurrent(User value) => current.value = value;

  void addUser(User value) {
    accounts.add(value);
    current.value = value;
  }
}
