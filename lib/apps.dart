import 'package:flutter/material.dart';

import 'package:redux/redux.dart';

import 'getx_sample/app.dart';
import 'mobx_sample/app.dart';
import 'bloc_sample/app.dart';
import 'basic_sample/app.dart';
import 'provider_sample/app.dart';

import 'redux_sample/app.dart';
import 'redux_sample/redux/app_state.dart';
import 'redux_sample/redux/reducers.dart';

class SixPathsStateApp extends StatelessWidget {
  final store = Store<AppState>(
    appReducers,
    initialState: AppState.initial(),
  );

  @override
  Widget build(BuildContext context) {
    final apps = [
      BasicApp(),
      ProviderApp(),
      CubitApp(),
      ReduxApp(store: store),
      MobxApp(),
      GetXApp(),
    ];

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text(this.toString())),
        body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(apps[index].toString()),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => apps[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
