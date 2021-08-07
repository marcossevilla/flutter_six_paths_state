import 'package:mobx/mobx.dart';
import 'package:six_paths_core/six_paths_core.dart';

part 'user_store.g.dart';

class UserStore extends _UserBase with _$UserStore {}

abstract class _UserBase with Store {
  @observable
  User? current;

  @observable
  ObservableList<User> accounts = ObservableList<User>();

  @action
  void addUser(User value) {
    accounts.add(value);
    setCurrent(value);
  }

  @action
  void setCurrent(User value) => current = value;
}
