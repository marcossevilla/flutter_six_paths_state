import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'app_redux/app_redux.dart';
export 'app_redux/app_redux.dart' show appReducers;

class ReduxApp extends StatelessWidget {
  const ReduxApp({Key? key, required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Redux',
        theme: ThemeData.dark(),
        home: _Home(),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  __HomeState createState() => __HomeState();
}

class __HomeState extends State<_Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Redux')),
      body: StoreConnector<AppState, String>(
        converter: (store) => store.state.current?.email ?? 'no-user',
        builder: (context, state) => Center(child: Text(state)),
      ),
      drawer: _MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New user'),
        onPressed: () {
          _scaffoldKey.currentState!.showBottomSheet<Widget>(
            (context) => _UserCard(),
          );
        },
      ),
    );
  }
}

class _UserCard extends StatefulWidget {
  const _UserCard({Key? key}) : super(key: key);

  @override
  __UserCardState createState() => __UserCardState();
}

class __UserCardState extends State<_UserCard> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';

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
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => _name = newValue!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => _email = newValue!),
                ),
                StoreConnector<AppState, OnAccountAdded>(
                  converter: (store) {
                    return (item) => store.dispatch(AddAccountAction(item));
                  },
                  builder: (context, addUser) {
                    return TextButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();

                        addUser(User(email: _email, name: _name));

                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    );
                  },
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
  const _MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: StoreConnector<AppState, List<User>>(
          converter: (store) => store.state.accounts,
          builder: (context, accounts) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                  ),
                  child: _DrawerHeader(),
                ),
                if (accounts.isNotEmpty)
                  for (var user in accounts) _AccountTile(user: user)
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnAccountAdded>(
      converter: (store) {
        return (item) => store.dispatch(SetCurrentUserAction(user));
      },
      builder: (context, setCurrent) {
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: () => setCurrent(user),
        );
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StoreConnector<AppState, String>(
          converter: (store) => store.state.current?.email ?? 'no-user',
          builder: (context, state) {
            return Text(state, style: TextStyle(color: Colors.black));
          },
        ),
      ],
    );
  }
}
