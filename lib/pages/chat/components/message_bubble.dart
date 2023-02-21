import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/helpers/date_helpers.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.doc,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  IconData getReadReceiptIcon(bool isReceived, bool isRead) {
    if (isReceived && !isRead) {
      return FontAwesomeIcons.check;
    }
    if (isReceived && isRead) {
      return FontAwesomeIcons.checkDouble;
    }
    return FontAwesomeIcons.clock;
  }

  @override
  Widget build(BuildContext context) {
    final isSentByMe =
        doc.data()['sender_uid'] == FirebaseAuth.instance.currentUser?.uid;
    final message = doc.data()['message'] as String;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      doc.data()['timestamp'] as int,
    );
    final isReceived = doc.data()['is_received'] as bool;
    final isRead = doc.data()['is_read'] as bool;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 150.0,
          maxWidth: 250.0,
        ),
        padding: EdgeInsets.all(0.25 * kPadding),
        decoration: ShapeDecoration(
          color: isSentByMe ? kPrimaryColor : kNeutralColors[1],
          shape: RoundedRectangleBorder(
            side: isSentByMe
                ? BorderSide.none
                : BorderSide(
                    color: kPrimaryColor,
                    width: kLineThickness,
                  ),
            borderRadius: BorderRadius.only(
              topLeft: isSentByMe
                  ? Radius.circular(0.7 * kBorderRadius)
                  : Radius.zero,
              topRight: isSentByMe
                  ? Radius.zero
                  : Radius.circular(0.7 * kBorderRadius),
              bottomLeft: Radius.circular(0.7 * kBorderRadius),
              bottomRight: Radius.circular(0.7 * kBorderRadius),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isSentByMe ? kNeutralColors[1] : kNeutralColors[0],
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 0.1 * kPadding),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateHelpers.getTimeText(dateTime),
                    style: TextStyle(
                      color: isSentByMe ? kNeutralColors[1] : kNeutralColors[0],
                      fontSize: 12.0,
                    ),
                  ),
                  if (isSentByMe)
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.25 * kPadding,
                      ),
                      child: Icon(
                        getReadReceiptIcon(isReceived, isRead),
                        color: kNeutralColors[1],
                        size: 14.0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
