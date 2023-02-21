import 'package:flutter/material.dart';
import 'package:hello/utils/constants.dart';

/// Todo: Implement dark mode

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(0.5 * kPadding),
        child: SwitchListTile(
          value: false,
          title: Text('Dark mode'),
          onChanged: (value) {},
        ),
      ),
    );
  }
}
