import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_six_paths_state/mobx_sample/stores/stores.dart';
import 'package:provider/provider.dart';
import 'package:six_paths_core/six_paths_core.dart';

class MobxApp extends StatelessWidget {
  const MobxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => UserStore(),
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.watch<UserStore>();
    return Scaffold(
      appBar: AppBar(title: const Text('MobX')),
      drawer: const UserDrawer(),
      body: Center(
        child: Observer(
          builder: (_) => Text(store.current?.email ?? 'no-user'),
        ),
      ),
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
        Scaffold.of(context).showBottomSheet<void>(
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
        child: const UserForm(),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
              validator: (value) => value!.trim().isEmpty ? 'Fill up' : null,
              onSaved: (newValue) => setState(() => name = newValue!),
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Email',
              ),
              validator: (value) => value!.trim().isEmpty ? 'Fill up' : null,
              onSaved: (newValue) => setState(() => email = newValue!),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                formKey.currentState!.save();

                context
                    .read<UserStore>()
                    .addUser(User(name: name, email: email));

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<UserStore>(context);
    const headerTextStyle = TextStyle(color: Colors.black);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: Observer(
          builder: (_) => ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    store.current?.name.characters.first.toUpperCase() ?? '?',
                  ),
                ),
                accountEmail: Text(
                  store.current?.email ?? 'no-email',
                  style: headerTextStyle,
                ),
                accountName: Text(
                  store.current?.email ?? 'no-name',
                  style: headerTextStyle,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              if (store.accounts.isNotEmpty)
                for (var account in store.accounts)
                  ListTile(
                    title: Text(account.name),
                    subtitle: Text(account.email),
                    onTap: () => store.current = account,
                  )
            ],
          ),
        ),
      ),
    );
  }
}
