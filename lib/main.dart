import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_six_paths_state/apps.dart';
import 'package:flutter_six_paths_state/bloc_sample/app_bloc_observer.dart';
import 'package:flutter_six_paths_state/redux_sample/app.dart';
import 'package:redux/redux.dart';

void main() {
  // [BlocObserver] from `bloc`
  Bloc.observer = AppBlocObserver();

  // [Store] configuration from `redux`
  final store = Store<AppState>(
    appReducers,
    initialState: AppState.initial(),
  );

  runApp(SixPathsStateApp(store: store));
}
