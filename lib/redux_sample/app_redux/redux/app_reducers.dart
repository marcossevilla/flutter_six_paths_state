import '../../../shared/models/user.dart';

part 'app_actions.dart';
part 'app_state.dart';

AppState appReducers(AppState state, dynamic action) {
  if (action is AddAccountAction) {
    return addAccount(state, action);
  } else if (action is SetCurrentUserAction) {
    return setCurrentUser(state, action);
  }
  return state;
}

AppState addAccount(AppState state, AddAccountAction action) {
  return AppState(action.account, state.accounts..add(action.account));
}

AppState setCurrentUser(AppState state, SetCurrentUserAction action) {
  return AppState(action.user, state.accounts);
}
