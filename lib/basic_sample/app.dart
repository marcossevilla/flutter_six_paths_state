import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:six_paths_core/six_paths_core.dart';

class BasicApp extends StatelessWidget {
  const BasicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const HomeView();
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  User? currentUser;
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setState'),
      ),
      body: Center(
        child: Text(currentUser?.email ?? 'no-user'),
      ),
      drawer: ProfileDrawer(
        currentUser: currentUser,
        users: users,
        onUpdate: () => updateUser(currentUser),
      ),
      floatingActionButton: ProfileAddAccountButton(addUser: addUser),
    );
  }

  void addUser(String name, String email) {
    final user = User(name: name, email: email);
    users.add(user);
    updateUser(user);
  }

  void updateUser(User? user) => setState(() => currentUser = user);
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    Key? key,
    required this.currentUser,
    required this.users,
    required this.onUpdate,
  }) : super(key: key);

  final User? currentUser;
  final List<User> users;
  final Function onUpdate;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.email ?? 'no-user',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            if (users.isNotEmpty)
              for (var user in users)
                ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () => onUpdate,
                )
          ],
        ),
      ),
    );
  }
}

class ProfileAddAccountButton extends StatelessWidget {
  const ProfileAddAccountButton({
    Key? key,
    required this.addUser,
  }) : super(key: key);

  final Function(String, String) addUser;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('New user'),
      onPressed: () {
        Scaffold.of(context).showBottomSheet<Widget>(
          (_) => UserCard(addUser: addUser),
        );
      },
    );
  }
}

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.addUser,
  }) : super(key: key);

  final Function(String, String) addUser;

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
                TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();

                    widget.addUser(_name, _email);

                    Navigator.of(context).pop();
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
