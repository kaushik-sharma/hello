import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/contacts/components/contact_card.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({
    super.key,
    required this.title,
    required this.contacts,
  });

  final String title;
  final List<MyContact> contacts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.5 * kPadding,
            vertical: 0.5 * kPadding,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15.0,
              color: kNeutralColors[0],
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (context, index) => ContactCard(
            contact: contacts[index],
          ),
        ),
      ],
    );
  }
}
