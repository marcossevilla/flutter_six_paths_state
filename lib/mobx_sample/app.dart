import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'stores/user_store.dart';
import '../shared/models/user.dart';

class MobxApp extends StatelessWidget {
  const MobxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => UserStore(),
      child: MaterialApp(
        title: 'Mobx',
        theme: ThemeData.dark(),
        home: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  _Home({Key key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UserStore>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('MobX')),
      drawer: _MyDrawer(),
      body: Center(
        child: Observer(
          builder: (_) => Text(store.current?.email ?? 'no-user'),
        ),
      ),
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

  String name;
  String email;

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
                  onSaved: (newValue) => setState(() => name = newValue),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                  ),
                  validator: (value) => value.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => email = newValue),
                ),
                FlatButton(
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    } else {
                      _formKey.currentState.save();

                      context.read<UserStore>().addUser(
                            User(name: name, email: email),
                          );

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
    final store = Provider.of<UserStore>(context);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: Observer(
          builder: (_) => ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.current?.email ?? 'no-user',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              if (store.accounts.isNotEmpty)
                for (var account in store.accounts)
                  ListTile(
                    title: Text(account.name),
                    subtitle: Text((account.email)),
                    onTap: () => store.current = account,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
