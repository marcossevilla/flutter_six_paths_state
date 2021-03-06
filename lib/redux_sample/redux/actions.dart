import '../../shared/models/user.dart';

abstract class UserAction {}

class AddAccountAction implements UserAction {
  final User account;

  AddAccountAction(this.account);
}

class SetCurrentUserAction implements UserAction {
  final User user;

  SetCurrentUserAction(this.user);
}
