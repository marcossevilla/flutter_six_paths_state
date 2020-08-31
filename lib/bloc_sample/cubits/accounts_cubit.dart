import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import '../../shared/models/user.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountState> {
  AccountsCubit() : super(AccountsInitial());

  List<User> accounts = [];

  void addUser(User user) {
    if (state is AccountsInitial) {
      emit(AccountsLoaded(accounts..add(user), user));
    } else if (state is AccountsLoaded) {
      emit(AccountsLoaded(accounts..add(user), user));
    }
  }

  void setCurrent(User user) => emit(AccountsLoaded(accounts, user));
}
