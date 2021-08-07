import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_six_paths_state/bloc_sample/app_bloc_observer.dart';
import 'package:redux/redux.dart';

import 'apps.dart';
import 'redux_sample/app_redux/app_redux.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  final store = Store<AppState>(
    appReducers,
    initialState: AppState.initial(),
  );

  runApp(SixPathsStateApp(store: store));
}
