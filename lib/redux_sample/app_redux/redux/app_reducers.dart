import 'package:six_paths_core/six_paths_core.dart';

part 'app_actions.dart';
part 'app_state.dart';

AppState appReducers(
  AppState state,
  dynamic action,
) {
  if (action is AddAccountAction) {
    return addAccount(state, action);
  } else if (action is SetCurrentUserAction) {
    return setCurrentUser(state, action);
  }
  return state;
}

AppState addAccount(
  AppState state,
  AddAccountAction action,
) {
  return AppState(
    current: action.account,
    accounts: [...state.accounts, action.account],
  );
}

AppState setCurrentUser(
  AppState state,
  SetCurrentUserAction action,
) {
  return AppState(
    current: action.user,
    accounts: state.accounts,
  );
}
