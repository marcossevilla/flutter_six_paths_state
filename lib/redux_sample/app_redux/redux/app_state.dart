part of 'app_reducers.dart';

typedef OnAccountAdded = Function(User user);

class AppState {
  final User? current;
  final List<User> accounts;

  AppState(this.current, this.accounts);

  factory AppState.initial() => AppState(null, []);
}
