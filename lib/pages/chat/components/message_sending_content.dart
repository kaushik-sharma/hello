import 'package:flutter/material.dart';
import 'package:hello/pages/chat/components/message_text_field.dart';
import 'package:hello/pages/chat/components/send_button.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/constants.dart';

class MessageSendingContent extends StatelessWidget {
  const MessageSendingContent({
    super.key,
    required this.receiverUid,
  });

  final String receiverUid;

  void sendMessage(TextEditingController controller) async {
    final message = controller.text.trim();
    if (message.isEmpty) {
      return;
    }
    controller.clear();
    await FirebaseServices.sendMessage(
      message: message,
      receiverUid: receiverUid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.5 * kPadding,
        vertical: 0.25 * kPadding,
      ),
      child: Row(
        children: [
          MessageTextField(controller: controller),
          SizedBox(width: 0.5 * kPadding),
          SendButton(
            onTap: () => sendMessage(controller),
          ),
        ],
      ),
    );
  }
}
