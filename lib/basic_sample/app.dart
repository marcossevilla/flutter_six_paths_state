import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared/models/user.dart';

class BasicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'setState',
      home: _Home(),
      theme: ThemeData.dark(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  __HomeState createState() => __HomeState();
}

class __HomeState extends State<_Home> {
  User? currentUser;
  List<User> users = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('setState')),
      body: Center(
        child: Text(currentUser?.email ?? 'no-user'),
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New user'),
        onPressed: () {
          _scaffoldKey.currentState!.showBottomSheet<Widget>(
            (context) => _UserCard(addUser: addUser),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
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
                    currentUser?.email ?? 'no-user',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            if (users.isNotEmpty)
              for (var user in users)
                ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () => updateUser(user),
                )
          ],
        ),
      ),
    );
  }

  void addUser(String name, String email) {
    final user = User(name: name, email: email);
    users.add(user);
    updateUser(user);
  }

  void updateUser(User user) => setState(() => currentUser = user);
}

class _UserCard extends StatefulWidget {
  const _UserCard({
    Key? key,
    required this.addUser,
  }) : super(key: key);

  final Function(String, String) addUser;

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
