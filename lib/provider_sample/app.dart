import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_six_paths_state/provider_sample/providers/providers.dart';
import 'package:provider/provider.dart';
import 'package:six_paths_core/six_paths_core.dart';

class ProviderApp extends StatelessWidget {
  const ProviderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserNotifier(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select(
      (UserNotifier notifier) => notifier.currentUser,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Center(
        child: Text(currentUser?.email ?? 'no-user'),
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
        Scaffold.of(context).showBottomSheet<void>(
          (_) => const UserCard(),
        );
      },
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({Key? key}) : super(key: key);

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

                context.read<UserNotifier>().addUser(
                      User(name: name, email: email),
                    );

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
    final userNotifier = context.watch<UserNotifier>();
    const headerTextStyle = TextStyle(color: Colors.black);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text(
                  userNotifier.currentUser?.name.characters.first ?? '?',
                ),
              ),
              accountEmail: Text(
                userNotifier.currentUser?.email ?? 'no-email',
                style: headerTextStyle,
              ),
              accountName: Text(
                userNotifier.currentUser?.name ?? 'no-name',
                style: headerTextStyle,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            if (userNotifier.users.isNotEmpty)
              for (var user in userNotifier.users)
                ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  onTap: () => context.read<UserNotifier>().currentUser = user,
                )
          ],
        ),
      ),
    );
  }
}
