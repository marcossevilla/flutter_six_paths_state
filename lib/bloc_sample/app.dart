import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/models/user.dart';
import 'cubit/accounts_cubit.dart';

class CubitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => AccountsCubit(),
        child: _Home(),
      ),
    );
  }
}

class _Home extends StatelessWidget {
  _Home({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('Cubit')),
      drawer: _MyDrawer(),
      body: BlocConsumer<AccountsCubit, AccountState>(
        listener: (context, state) => debugPrint(state.toString()),
        builder: (context, state) {
          if (state is AccountsInitial) {
            return Center(child: Text('no-user'));
          } else if (state is AccountsLoaded) {
            return Center(child: Text(state.current.email));
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
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
                TextButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();

                    final accountCubit = context.read<AccountsCubit>();
                    accountCubit.addUser(User(name: _name, email: _email));

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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: BlocConsumer<AccountsCubit, AccountState>(
          listener: (context, state) => debugPrint(state.toString()),
          builder: (context, state) {
            return ListView(
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
                      if (state is AccountsInitial)
                        Text(
                          'no-user',
                          style: TextStyle(color: Colors.black),
                        ),
                      if (state is AccountsLoaded)
                        Text(
                          state.current.email,
                          style: TextStyle(color: Colors.black),
                        ),
                    ],
                  ),
                ),
                if (state is AccountsLoaded)
                  for (var user in state.accounts)
                    ListTile(
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      onTap: () {
                        context.read<AccountsCubit>().setCurrent(user);
                      },
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}
