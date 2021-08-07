import 'package:flutter/material.dart';

import 'package:redux/redux.dart';

import 'getx_sample/app.dart';
import 'mobx_sample/app.dart';
import 'bloc_sample/app.dart';
import 'basic_sample/app.dart';
import 'provider_sample/app.dart';

import 'redux_sample/app.dart';
import 'redux_sample/app_redux/app_redux.dart';

class SixPathsStateApp extends StatelessWidget {
  const SixPathsStateApp({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    final apps = [
      BasicApp(),
      ProviderApp(),
      BlocApp(),
      ReduxApp(store: store),
      MobxApp(),
      GetXApp(),
    ];

    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: Text('$this')),
        body: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${apps[index]}'),
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
