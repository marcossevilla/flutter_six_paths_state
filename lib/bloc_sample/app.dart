import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_cubit/flutter_cubit.dart';

import '../shared/models/user.dart';

class CubitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit App',
      theme: ThemeData.dark(),
      home: MultiCubitProvider(
        providers: [],
        child: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  _Home({Key key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Cubit')),
      drawer: _MyDrawer(),
      body: Text('no-user'),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New user'),
        onPressed: () {
          _scaffoldKey.currentState.showBottomSheet<Widget>(
            (context) => _UserCard(),
          );
        },
      ),
    );
  }
}

class _UserCard extends StatefulWidget {
  const _UserCard({Key key}) : super(key: key);

  @override
  __UserCardState createState() => __UserCardState();
}

class __UserCardState extends State<_UserCard> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Name',
                  ),
                  validator: (value) => value.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => _name = newValue),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                  ),
                  validator: (value) => value.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => _email = newValue),
                ),
                FlatButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    } else {
                      _formKey.currentState.save();

                      User(name: _name, email: _email);

                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyDrawer extends StatelessWidget {
  const _MyDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'no-user',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            // for (var user in )
            //   ListTile(
            //     title: Text(user.name),
            //     subtitle: Text(user.email),
            //     onTap: () => user = user,
            //   )
          ],
        ),
      ),
    );
  }
}
