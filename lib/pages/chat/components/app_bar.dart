import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/helpers/date_helpers.dart';
import 'package:hello/helpers/phone_number_helpers.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:marquee/marquee.dart';

PreferredSizeWidget buildAppBar({
  required BuildContext context,
  required String userUid,
}) {
  return AppBar(
    titleSpacing: 0.0,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back),
        ),
        _UserInfo(userUid: userUid),
      ],
    ),
  );
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({
    required this.userUid,
  });

  final String userUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseServices.getUserStream(
        context: context,
        userUid: userUid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        final data = snapshot.data?.data();
        if (data == null) {
          return SizedBox();
        }

        final profileImageUrl = data['profile_image_url'] as String;

        final phoneNumber = data['phone_number'] as String;
        final name = _getSavedName(phoneNumber);

        final isOnline = data['is_online'] as bool;
        final lastSeen = DateTime.fromMillisecondsSinceEpoch(
          data['last_seen_timestamp'] as int,
        );

        return Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: kNeutralColors[2],
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : AssetImage('assets/images/default-profile-image.png')
              as ImageProvider,
            ),
            SizedBox(width: 0.3 * kPadding),
            SizedBox(
              width: 140.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? PhoneNumberHelpers.formatPhoneNumber(phoneNumber),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 0.1 * kPadding),
                  isOnline
                      ? Text(
                    'online',
                    style: TextStyle(fontSize: 13.0),
                  )
                      : SizedBox(
                    height: 20.0,
                    child: Marquee(
                      text: _getLastSeenText(lastSeen),
                      style: TextStyle(fontSize: 13.0),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 100.0,
                      pauseAfterRound: Duration(seconds: 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

String? _getSavedName(String phoneNumber) {
  for (final contact in ContactsModel.registeredContacts) {
    if (contact.phoneNumber == phoneNumber) {
      return contact.name;
    }
  }
  return null;
}

String _getLastSeenText(DateTime lastSeen) {
  if (DateHelpers.isToday(lastSeen)) {
    return 'last seen today at ${DateHelpers.getTimeText(lastSeen)}';
  }
  if (DateHelpers.isYesterday(lastSeen)) {
    return 'last seen yesterday at ${DateHelpers.getTimeText(lastSeen)}';
  }
  return 'last seen on ${DateHelpers.getDateText(lastSeen)}';
}
