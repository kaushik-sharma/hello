import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const routeName = 'settings';

  void launchGithubLink(VoidCallback errorCallback) async {
    final uri = Uri.parse('https://github.com/kaushik-sharma/hello');
    if (!(await url_launcher.canLaunchUrl(uri))) {
      errorCallback();
      return;
    }
    await url_launcher.launchUrl(uri);
  }

  VoidCallback errorHandler(BuildContext context) {
    return () => buildSnackBar(
          context: context,
          backgroundColor: kErrorColor,
          message: 'Failed to launch URL. Please retry.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(0.5 * kPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => launchGithubLink(errorHandler(context)),
              style: TextButton.styleFrom(foregroundColor: Colors.black),
              icon: Icon(
                FontAwesomeIcons.github,
                size: 30.0,
              ),
              label: Text(
                'Source code',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
