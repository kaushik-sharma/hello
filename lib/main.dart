import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello/pages/account/account_page.dart';
import 'package:hello/pages/chat/chat_page.dart';
import 'package:hello/pages/contacts/contacts_page.dart';
import 'package:hello/pages/home/home_page.dart';
import 'package:hello/pages/loading/loading_page.dart';
import 'package:hello/pages/settings/settings_page.dart';
import 'package:hello/pages/sign_in/sign_in_page.dart';
import 'package:hello/pages/sign_up/sign_up_page.dart';
import 'package:hello/pages/sms_code/sms_code_page.dart';
import 'package:hello/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hello',
      theme: buildTheme(),
      home: FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingPage()
            : FutureBuilder<void>(
                future: FirebaseAuth.instance.currentUser?.reload(),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? LoadingPage()
                    : StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? LoadingPage()
                                : snapshot.hasData
                                    ? HomePage()
                                    : SignInPage(),
                      ),
              ),
      ),
      routes: {
        LoadingPage.routeName: (context) => LoadingPage(),
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        SmsCodePage.routeName: (context) => SmsCodePage(),
        HomePage.routeName: (context) => HomePage(),
        ChatPage.routeName: (context) => ChatPage(),
        AccountPage.routeName: (context) => AccountPage(),
        ContactsPage.routeName: (context) => ContactsPage(),
        SettingsPage.routeName: (context) => SettingsPage(),
      },
    );
  }
}
