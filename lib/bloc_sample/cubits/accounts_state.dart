part of 'accounts_cubit.dart';

@immutable
abstract class AccountState {
  const AccountState();
}

class AccountsInitial extends AccountState {
  final User current;
  final List<User> accounts;

  const AccountsInitial({this.accounts = const [], this.current});
}

class AccountsLoaded extends AccountState {
  final User current;
  final List<User> accounts;

  const AccountsLoaded(this.accounts, this.current);
}
