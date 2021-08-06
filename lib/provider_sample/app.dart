import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../shared/models/user.dart';
import 'providers/user_provider.dart';

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'Provider',
        theme: ThemeData.dark(),
        home: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  _Home({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (UserProvider provider) => provider.currentUser,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Provider')),
      drawer: _MyDrawer(),
      body: Center(child: Text(currentUser?.email ?? 'no-user')),
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

  String name = '';
  String email = '';

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
                  onSaved: (newValue) => setState(() => name = newValue!),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Fill up' : null,
                  onSaved: (newValue) => setState(() => email = newValue!),
                ),
                TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    _formKey.currentState!.save();
                    context.read<UserProvider>().addUser(
                          User(name: name, email: email),
                        );
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

class _MyDrawer extends StatelessWidget {
  const _MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);

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
                    provider.currentUser?.email ?? 'no-user',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            if (provider.users.isNotEmpty)
              for (var user in provider.users)
                ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () => context.read<UserProvider>().currentUser = user,
                )
          ],
        ),
      ),
    );
  }
}
