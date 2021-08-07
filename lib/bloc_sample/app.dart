import 'package:flutter/material.dart';

import 'profile/profile.dart';

class BlocApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc',
      theme: ThemeData.dark(),
      home: ProfilePage(),
    );
  }
}
