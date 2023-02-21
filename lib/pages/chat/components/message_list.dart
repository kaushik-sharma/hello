import 'package:hello/helpers/chat_helpers.dart';
import 'package:hello/pages/chat/components/date_divider.dart';
import 'package:hello/pages/chat/components/message_bubble.dart';
import 'package:hello/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    super.key,
    required this.docs,
  });

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  @override
  Widget build(BuildContext context) {
    final uniqueDates = ChatHelpers.extractUniqueDates(docs);
    final messageGroups = ChatHelpers.extractMessageGroups(docs, uniqueDates);

    return ListView.separated(
      reverse: true,
      padding: EdgeInsets.all(0.5 * kPadding),
      itemCount: uniqueDates.length,
      itemBuilder: (context, index) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DateDivider(date: uniqueDates[index]),
          SizedBox(height: kPadding),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: messageGroups[index].length,
            itemBuilder: (context, i) =>
                MessageBubble(doc: messageGroups[index][i]),
            separatorBuilder: (context, i) => SizedBox(height: 0.25 * kPadding),
          ),
        ],
      ),
      separatorBuilder: (context, index) => SizedBox(height: kPadding),
    );
  }
}
