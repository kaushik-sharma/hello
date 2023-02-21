import 'package:flutter/material.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/chat/chat_page.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
  });

  final MyContact contact;
  
  void goToChatPage(BuildContext context) {
    if (contact.uid.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(
        ChatPage.routeName,
        arguments: contact.uid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goToChatPage(context),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0.5 * kPadding,
            vertical: 0.25 * kPadding,
        ),
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: kNeutralColors[2],
          backgroundImage: contact.image,
        ),
        title: Text(
          contact.name,
          style: TextStyle(
            color: kNeutralColors[0],
          ),
        ),
      ),
    );
  }
}
