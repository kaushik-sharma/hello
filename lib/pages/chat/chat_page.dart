import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello/pages/chat/components/app_bar.dart';
import 'package:hello/pages/chat/components/message_list.dart';
import 'package:hello/pages/chat/components/message_sending_content.dart';
import 'package:hello/services/firebase_services.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  static const routeName = 'chat';

  @override
  Widget build(BuildContext context) {
    final userUid = ModalRoute.of(context)?.settings.arguments as String;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: buildAppBar(context: context, userUid: userUid),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<QuerySnapshot<Map<String, dynamic>>>>(
                stream: FirebaseServices.getMessageStreams(
                  context: context,
                  userUid: userUid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }
                  if (snapshot.hasError) {
                    return SizedBox();
                  }

                  final docs = <QueryDocumentSnapshot<Map<String, dynamic>>>[
                    ...(snapshot.data?[0].docs ?? []),
                    ...(snapshot.data?[1].docs ?? []),
                  ];

                  return MessageList(docs: docs);
                },
              ),
            ),
            MessageSendingContent(
              receiverUid: userUid,
            ),
          ],
        ),
      ),
    );
  }
}
