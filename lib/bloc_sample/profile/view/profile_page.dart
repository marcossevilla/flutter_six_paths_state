import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_six_paths_state/bloc_sample/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc')),
      drawer: ProfileDrawer(),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (_, state) {
          if (state is ProfileInitial) {
            return Center(child: Text('no-user'));
          } else if (state is ProfileLoaded) {
            return Center(child: Text(state.current.email));
          } else {
            return Center(child: Text('error'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New user'),
        onPressed: () {
          Scaffold.of(context).showBottomSheet((_) => ProfileCard());
        },
      ),
    );
  }
}
