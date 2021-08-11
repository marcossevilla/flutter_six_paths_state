import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_six_paths_state/redux_sample/app_redux/app_redux.dart';
import 'package:redux/redux.dart';
import 'package:six_paths_core/six_paths_core.dart';

export 'app_redux/app_redux.dart' show appReducers, AppState;

class ReduxApp extends StatelessWidget {
  const ReduxApp({
    Key? key,
    required Store<AppState> store,
  })  : _store = store,
        super(key: key);

  final Store<AppState> _store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _store,
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redux'),
      ),
      body: StoreConnector<AppState, String>(
        converter: (store) => store.state.current?.email ?? 'no-user',
        builder: (_, state) => Center(child: Text(state)),
      ),
      drawer: const UserDrawer(),
      floatingActionButton: const ProfileAddAccountButton(),
    );
  }
}

class ProfileAddAccountButton extends StatelessWidget {
  const ProfileAddAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('New user'),
      onPressed: () {
        Scaffold.of(context).showBottomSheet<Widget>(
          (_) => const UserCard(),
        );
      },
    );
  }
}

class UserCard extends StatefulWidget {
  const UserCard({Key? key}) : super(key: key);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 12,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

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
                  child: const _DrawerHeader(),
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
            return Text(
              state,
              style: const TextStyle(color: Colors.black),
            );
          },
        ),
      ],
    );
  }
}
