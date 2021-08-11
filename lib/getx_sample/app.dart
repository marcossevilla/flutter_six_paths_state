import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_six_paths_state/getx_sample/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:six_paths_core/six_paths_core.dart';

class GetXApp extends StatelessWidget {
  const GetXApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    // * this GetMaterial app is a GetX widget
    return GetMaterialApp(
      title: 'GetX',
      theme: ThemeData.dark(),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(title: const Text('GetX')),
      drawer: const UserDrawer(),
      body: Center(
        child: Obx(() => Text(userController.current.value.email)),
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

  String name = '';
  String email = '';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
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
                    controller.addUser(User(name: name, email: email));

                    Navigator.of(context).pop();
                    Get.snackbar<Widget>('Saved!', 'User saved successfully');
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
    final controller = Get.find<UserController>();

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
                      controller.current.value.email,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              if (controller.accounts.isNotEmpty)
                for (var user in controller.accounts)
                  ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () => controller.changeCurrent(user),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
