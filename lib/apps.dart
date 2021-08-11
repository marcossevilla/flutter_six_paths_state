import 'package:flutter/material.dart';
import 'package:flutter_six_paths_state/basic_sample/app.dart';
import 'package:flutter_six_paths_state/bloc_sample/app.dart';
import 'package:flutter_six_paths_state/getx_sample/app.dart';
import 'package:flutter_six_paths_state/mobx_sample/app.dart';
import 'package:flutter_six_paths_state/provider_sample/app.dart';
import 'package:flutter_six_paths_state/redux_sample/app.dart';
import 'package:redux/redux.dart';

class SixPathsStateApp extends StatelessWidget {
  const SixPathsStateApp({
    Key? key,
    required this.store,
  }) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    final apps = [
      const BasicApp(),
      const ProviderApp(),
      const BlocApp(),
      ReduxApp(store: store),
      const MobxApp(),
      const GetXApp(),
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
              onTap: () => Navigator.of(context).push<Widget>(
                MaterialPageRoute(builder: (context) => apps[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
