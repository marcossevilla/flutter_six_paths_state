import 'package:flutter/material.dart';

// import 'mobx_sample/app.dart';
// import 'bloc_sample/app.dart';
// import 'basic_sample/app.dart';
// import 'provider_sample/app.dart';

// * main for most apps
// void main() => runApp(MobxApp());

// * config for redux
import 'package:redux/redux.dart';

import 'redux_sample/app.dart';
import 'redux_sample/redux/app_state.dart';
import 'redux_sample/redux/reducers.dart';

void main() {
  final store = Store<AppState>(
    appReducers,
    initialState: AppState.initial(),
  );

  runApp(ReduxApp(store: store));
}
