import 'package:flutter/material.dart';
import 'package:shop_admin/constants/routes.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
    runSpacing: 16,
    children: [
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        tileColor: Colors.black45,
        onTap: () {
          Navigator.of(context).pushReplacementNamed(categoryRoute);
        },
      ),
      ListTile(
        leading: const Icon(Icons.star),
        title: const Text('Favourites'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.workspaces),
        title: const Text('Workflow'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.update),
        title: const Text('Updates'),
        onTap: () {},
      ),
    ],
  );
}
