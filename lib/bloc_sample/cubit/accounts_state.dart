part of 'accounts_cubit.dart';

@immutable
abstract class AccountState {
  const AccountState();
}

class AccountsInitial extends AccountState {}

class AccountsLoaded extends AccountState {
  final User current;
  final List<User> accounts;

  const AccountsLoaded(this.accounts, this.current);
}
