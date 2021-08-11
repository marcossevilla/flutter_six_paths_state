part of 'app_reducers.dart';

typedef OnAccountAdded = Function(User user);

class AppState {
  const AppState({
    this.current,
    required this.accounts,
  });

  factory AppState.initial() => const AppState(accounts: []);

  final User? current;
  final List<User> accounts;
}
