part of 'app_reducers.dart';

abstract class UserAction {}

class AddAccountAction implements UserAction {
  const AddAccountAction(this.account);
  final User account;
}

class SetCurrentUserAction implements UserAction {
  const SetCurrentUserAction(this.user);
  final User user;
}
