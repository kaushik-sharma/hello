import 'package:flutter/material.dart';

class ContactsModel {
  static final registeredContacts = <MyContact>[];
  static final unregisteredContacts = <MyContact>[];
}

class MyContact {
  final String name;
  final String phoneNumber;
  final ImageProvider image;
  final String uid;

  const MyContact({
    required this.name,
    required this.phoneNumber,
    required this.image,
    required this.uid,
  });
}
