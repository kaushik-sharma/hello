import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello/helpers/date_helpers.dart';
import 'package:hello/helpers/phone_number_helpers.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/chat/chat_page.dart';
import 'package:hello/pages/home/components/shimmer_chat_card.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.userUid,
    required this.latestMessage,
  });

  final String userUid;
  final QueryDocumentSnapshot<Map<String, dynamic>> latestMessage;

  String? getSavedName(String phoneNumber) {
    for (final contact in ContactsModel.registeredContacts) {
      if (contact.phoneNumber == phoneNumber) {
        return contact.name;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseServices.getUserInfo(
        context: context,
        userUid: userUid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerChatCard();
        }

        final user = snapshot.data;

        if (user == null) {
          return SizedBox();
        }

        final userData = user.data();

        if (userData == null) {
          return SizedBox();
        }

        final phoneNumber = userData['phone_number'] as String;
        final name = getSavedName(phoneNumber);
        final profileImageUrl = userData['profile_image_url'] as String;
        final content = latestMessage.data()['message'] as String;
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          latestMessage.data()['timestamp'] as int,
        );

        return InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            ChatPage.routeName,
            arguments: user.id,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0.5 * kPadding,
              vertical: 0.3 * kPadding,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.0,
                  backgroundColor: kNeutralColors[2],
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : AssetImage(
                          'assets/images/default-profile-image.png',
                        ) as ImageProvider,
                ),
                SizedBox(width: 0.5 * kPadding),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              name ??
                                  PhoneNumberHelpers.formatPhoneNumber(
                                    phoneNumber,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kNeutralColors[0],
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            DateHelpers.isToday(dateTime)
                                ? DateHelpers.getTimeText(dateTime)
                                : DateHelpers.getDateText(dateTime),
                            style: TextStyle(
                              color: kNeutralColors[2],
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.1 * kPadding),
                      SizedBox(
                        width: 200.0,
                        child: Text(
                          content,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: kNeutralColors[2],
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
