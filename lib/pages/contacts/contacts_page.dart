import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/contacts/components/contacts_list.dart';
import 'package:hello/pages/contacts/components/create_group_button.dart';
import 'package:hello/pages/contacts/components/shimmer_contact_card_list.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  static const routeName = 'contacts';

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  var _isLoading = false;

  Future<void> _reloadContacts() async {
    _isLoading = true;
    setState(() {});
    await FirebaseServices.saveContactsData(context: context);
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: [
          IconButton(
            onPressed: _reloadContacts,
            icon: Icon(FontAwesomeIcons.arrowsRotate),
          ),
        ],
      ),
      body: _isLoading
          ? ShimmerContactCardList()
          : ListView(
              children: [
                CreateGroupButton(),
                if (ContactsModel.registeredContacts.isNotEmpty)
                  ContactsList(
                    title: 'Contacts on Hello',
                    contacts: ContactsModel.registeredContacts,
                  ),
                if (ContactsModel.unregisteredContacts.isNotEmpty)
                  ContactsList(
                    title: 'Invite to Hello',
                    contacts: ContactsModel.unregisteredContacts,
                  ),
              ],
            ),
    );
  }
}

