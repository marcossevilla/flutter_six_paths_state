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
          children: const [
            ProfileHeader(),
            ProfileAccountList(),
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
    const headerTextStyle = TextStyle(color: Colors.black);
    return BlocSelector<ProfileBloc, ProfileState, List<String>>(
      selector: (state) {
        if (state is ProfileLoaded) {
          return [state.current.email, state.current.name];
        } else {
          return ['no-email', 'no-name'];
        }
      },
      builder: (context, state) {
        return UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            child: Text(state.first.characters.first.toUpperCase()),
          ),
          currentAccountPictureSize: const Size.square(50),
          accountName: Text(state.first, style: headerTextStyle),
          accountEmail: Text(state.last, style: headerTextStyle),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
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
          return Column(
            children: [
              for (final account in accounts)
                ListTile(
                  title: Text(account.name),
                  subtitle: Text(account.email),
                  onTap: () {
                    final event = ProfileCurrentAccountChanged(account);
                    context.read<ProfileBloc>().add(event);
                  },
                )
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
