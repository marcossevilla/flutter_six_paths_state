import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_six_paths_state/bloc_sample/profile/profile.dart';
import 'package:six_paths_core/six_paths_core.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

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
              child: const ProfileHeader(),
            ),
            const ProfileAccountList(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textHeaderStyle = TextStyle(color: Colors.black);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (_, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is ProfileInitial)
              Text('no-user', style: textHeaderStyle),
            if (state is ProfileLoaded)
              Text(state.current.email, style: textHeaderStyle),
          ],
        );
      },
    );
  }
}

class ProfileAccountList extends StatelessWidget {
  const ProfileAccountList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProfileBloc, ProfileState, List<User>>(
      selector: (state) {
        if (state is ProfileLoaded) return state.accounts;
        return [];
      },
      builder: (_, accounts) {
        if (accounts.isNotEmpty) {
          for (final account in accounts) {
            return ListTile(
              title: Text(account.name),
              subtitle: Text(account.email),
              onTap: () {
                final event = ProfileCurrentAccountChanged(account);
                context.read<ProfileBloc>().add(event);
              },
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}