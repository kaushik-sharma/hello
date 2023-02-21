import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/common/loading_indicator.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/services/firebase_services.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';

class CreateGroupButton extends StatelessWidget {
  const CreateGroupButton({super.key});

  void showCreateGroupForm(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: _CreateGroupForm(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showCreateGroupForm(context),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 0.5 * kPadding,
          vertical: 0.25 * kPadding,
        ),
        leading: Icon(
          FontAwesomeIcons.userGroup,
          color: kPrimaryColor,
        ),
        title: Text(
          'Create group',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}

class _CreateGroupForm extends StatefulWidget {
  const _CreateGroupForm();

  @override
  State<_CreateGroupForm> createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<_CreateGroupForm> {
  var _isLoading = false;

  final _controller = TextEditingController();
  final _participantsUids = <String>[];

  void _selectParticipant(bool? isSelected, int index) {
    if (isSelected == null) {
      return;
    }

    if (isSelected) {
      _participantsUids.add(
        ContactsModel.registeredContacts[index].uid,
      );
    } else {
      _participantsUids.remove(
        ContactsModel.registeredContacts[index].uid,
      );
    }
    setState(() {});
  }

  bool _validateGroupName() {
    if (_controller.text.isEmpty) {
      buildSnackBar(
        context: context,
        message: 'Please provide a group name.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  bool _validateParticipantsUids() {
    if (_participantsUids.isEmpty) {
      buildSnackBar(
        context: context,
        message: 'Please select at least one contact.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
    return true;
  }

  Future<void> _createGroup() async {
    if (!_validateGroupName()) {
      return;
    }
    if (!_validateParticipantsUids()) {
      return;
    }

    _isLoading = true;
    setState(() {});

    final isSuccess = await FirebaseServices.createGroup(
      context: context,
      name: _controller.text,
      participantsUids: _participantsUids,
    );

    _isLoading = false;
    setState(() {});

    if (!isSuccess) {
      return;
    }

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Padding(
        padding: EdgeInsets.all(0.5 * kPadding),
        child: _isLoading
            ? LoadingIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create new group',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: kNeutralColors[0],
                    ),
                  ),
                  SizedBox(height: 0.5 * kPadding),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Group name'),
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(kMaxGroupNameLength),
                    ],
                    controller: _controller,
                  ),
                  SizedBox(height: 0.5 * kPadding),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select participants',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: kNeutralColors[0],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5 * kPadding),
                  SizedBox(
                    height: 250.0,
                    child: ListView.builder(
                      itemCount: ContactsModel.registeredContacts.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                        value: _participantsUids.contains(
                          ContactsModel.registeredContacts[index].uid,
                        ),
                        title: Text(
                          ContactsModel.registeredContacts[index].name,
                        ),
                        onChanged: (value) => _selectParticipant(value, index),
                      ),
                    ),
                  ),
                  SizedBox(height: 0.5 * kPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: kErrorColor,
                        ),
                        onPressed: Navigator.of(context).pop,
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: _createGroup,
                        child: Text('Continue'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
