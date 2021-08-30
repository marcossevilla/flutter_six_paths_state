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
    final controller = Get.find<UserController>();
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

                controller.addUser(User(name: name, email: email));

                Navigator.of(context).pop();
                Get.snackbar<void>('Saved!', 'User saved successfully');
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
    const headerTextStyle = TextStyle(color: Colors.black);
    final controller = Get.find<UserController>();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Drawer(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Text(
                    controller.current.value.name.characters.first
                        .toUpperCase(),
                  ),
                ),
                accountEmail: Text(
                  controller.current.value.email,
                  style: headerTextStyle,
                ),
                accountName: Text(
                  controller.current.value.name,
                  style: headerTextStyle,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
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
