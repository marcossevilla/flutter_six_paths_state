import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_paths_core/six_paths_core.dart';

import 'controllers/user_controller.dart';

class GetXApp extends StatelessWidget {
  const GetXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    // * this GetMaterial app is a GetX widget
    return GetMaterialApp(
      title: 'GetX',
      theme: ThemeData.dark(),
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('GetX')),
      drawer: UserDrawer(),
      body: Center(
        child: Obx(() => Text(_controller.current.value.email)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New user'),
        onPressed: () {
          Scaffold.of(context).showBottomSheet<Widget>((_) => UserCard());
        },
      ),
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
  final _controller = Get.find<UserController>();

  String name = '';
  String email = '';

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
                    _controller.addUser(User(name: name, email: email));

                    Navigator.of(context).pop();
                    Get.snackbar('Saved!', 'User saved successfully');
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

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserController _controller = Get.find();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: Obx(
          () => ListView(
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
                      _controller.current.value.email,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              if (_controller.accounts.isNotEmpty)
                for (var user in _controller.accounts)
                  ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () => _controller.setCurrent(user),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
