import '../../shared/models/user.dart';

typedef OnAccountAdded = Function(User user);

class AppState {
  final User current;
  final List<User> accounts;

  AppState(this.current, this.accounts);

  factory AppState.initial() => AppState(User(), []);
}
