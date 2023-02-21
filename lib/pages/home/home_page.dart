import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/helpers/chat_helpers.dart';
import 'package:hello/pages/account/account_page.dart';
import 'package:hello/pages/common/more_options_button.dart';
import 'package:hello/pages/contacts/contacts_page.dart';
import 'package:hello/pages/home/components/chat_card.dart';
import 'package:hello/pages/home/components/shimmer_chat_card.dart';
import 'package:hello/pages/settings/settings_page.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _items = [
    'Account',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    FirebaseServices.setUserOnlineStatus(true);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FirebaseServices.setUserOnlineStatus(true);
    } else {
      FirebaseServices.setUserOnlineStatus(false);
    }
  }

  void _itemOnTap(String selectedItem) {
    if (selectedItem == _items[0]) {
      Navigator.of(context).pushNamed(AccountPage.routeName);
      return;
    }
    if (selectedItem == _items[1]) {
      Navigator.of(context).pushNamed(SettingsPage.routeName);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app-logo.png',
              width: 40.0,
              height: 40.0,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 0.25 * kPadding),
            Text(
              'Hello',
              style: TextStyle(
                fontSize: 26.0,
                color: kPrimaryColor,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        actions: [
          MoreOptionsButton(
            items: _items,
            itemOnTap: _itemOnTap,
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: FirebaseServices.saveContactsData(context: context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) => ShimmerChatCard(),
            );
          }
          if (snapshot.hasError) {
            return SizedBox();
          }

          return StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
            stream: FirebaseServices.getChatStreams(context: context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 20,
                  itemBuilder: (context, index) => ShimmerChatCard(),
                );
              }
              if (snapshot.hasError) {
                return SizedBox();
              }

              final docs = ChatHelpers.sortDocsByDateTime(
                <QueryDocumentSnapshot<Map<String, dynamic>>>[
                  ...(snapshot.data?[0].docs ?? []),
                  ...(snapshot.data?[1].docs ?? []),
                ],
                descending: true,
              );

              if (docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(kPadding),
                    child: Text(
                      'No conversations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        color: kNeutralColors[2],
                      ),
                    ),
                  ),
                );
              }

              final userUids = ChatHelpers.extractUserUids(docs);
              final latestMessages =
                  ChatHelpers.extractLatestMessagesGroupWise(docs, userUids);

              return ListView.builder(
                itemCount: userUids.length,
                itemBuilder: (context, index) => ChatCard(
                  userUid: userUids[index],
                  latestMessage: latestMessages[index],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          ContactsPage.routeName,
        ),
        child: Icon(
          FontAwesomeIcons.addressBook,
        ),
      ),
    );
  }
}
