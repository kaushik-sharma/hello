import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hello/helpers/phone_number_helpers.dart';
import 'package:hello/models/auth_model.dart';
import 'package:hello/models/contacts_model.dart';
import 'package:hello/pages/common/material_banner.dart';
import 'package:hello/pages/common/snack_bar.dart';
import 'package:hello/utils/color_palette.dart';
import 'package:hello/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseServices {
  static Future<bool?> isPhoneNumberRegistered({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'phone_number',
            isEqualTo: phoneNumber,
          )
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to find phone number. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  static Future<void> sendVerificationCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: kSmsCodeTimeout,
        forceResendingToken: AuthModel.forceResendingToken,
        codeSent: (verificationId, forceResendingToken) {
          AuthModel.verificationId = verificationId;
          AuthModel.forceResendingToken = forceResendingToken;
        },
        verificationCompleted: (phoneAuthCredential) {
          // Todo: Implement sms code auto retrieval
        },
        verificationFailed: (firebaseAuthException) {
          buildSnackBar(
            context: context,
            message: firebaseAuthException.message.toString(),
            backgroundColor: kErrorColor,
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          AuthModel.verificationId = verificationId;
        },
      );
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to send verification code. Please retry.',
        backgroundColor: kErrorColor,
      );
    }
  }

  static Future<bool> signIn({
    required BuildContext context,
  }) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        smsCode: AuthModel.smsCode,
        verificationId: AuthModel.verificationId,
      );
      await FirebaseAuth.instance.signInWithCredential(
        phoneAuthCredential,
      );
      return true;
    } on FirebaseAuthException {
      buildSnackBar(
        context: context,
        message: 'The code entered is invalid.',
        backgroundColor: kErrorColor,
      );
      return false;
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to sign in. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  static Future<bool> createUser({
    required BuildContext context,
    required String name,
    required File? image,
  }) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        smsCode: AuthModel.smsCode,
        verificationId: AuthModel.verificationId,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        phoneAuthCredential,
      );

      var imageUrl = '';
      if (image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${userCredential.user?.uid}');
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set(
        {
          'name': name,
          'phone_number': userCredential.user?.phoneNumber,
          'profile_image_url': imageUrl,
          'is_online': true,
          'last_seen_timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );

      return true;
    } on FirebaseAuthException {
      buildSnackBar(
        context: context,
        message: 'The code entered is invalid.',
        backgroundColor: kErrorColor,
      );
      return false;
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to create account. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  static Future<void> signOut({
    required BuildContext context,
  }) async {
    try {
      Navigator.of(context).popUntil((route) => route.isFirst);
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to sign out. Please retry.',
        backgroundColor: kErrorColor,
      );
    }
  }

  /// Todo: Implement sending media messages
  /// Todo: Implement delivery receipts
  static Future<void> sendMessage({
    required String message,
    required String receiverUid,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add(
        {
          'sender_uid': FirebaseAuth.instance.currentUser?.uid,
          'receiver_uid': receiverUid,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'message': message,
          'is_received': false,
          'is_read': false,
        },
      );
    } catch (_) {}
  }

  static CombineLatestStream<dynamic,
      List<QuerySnapshot<Map<String, dynamic>>>>? getChatStreams({
    required BuildContext context,
  }) {
    try {
      final collection = FirebaseFirestore.instance.collection('messages');
      final stream1 = collection
          .where(
            'sender_uid',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .snapshots();
      final stream2 = collection
          .where(
            'receiver_uid',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .snapshots();

      return CombineLatestStream.combine2<
          QuerySnapshot<Map<String, dynamic>>,
          QuerySnapshot<Map<String, dynamic>>,
          List<QuerySnapshot<Map<String, dynamic>>>>(
        stream1,
        stream2,
        (firstStream, secondStream) => [firstStream, secondStream],
      );
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to load messages. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  static CombineLatestStream<dynamic,
      List<QuerySnapshot<Map<String, dynamic>>>>? getMessageStreams({
    required BuildContext context,
    required String userUid,
  }) {
    try {
      final collection = FirebaseFirestore.instance.collection('messages');
      final stream1 = collection
          .where(
            'sender_uid',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .where(
            'receiver_uid',
            isEqualTo: userUid,
          )
          .snapshots();
      final stream2 = collection
          .where(
            'sender_uid',
            isEqualTo: userUid,
          )
          .where(
            'receiver_uid',
            isEqualTo: FirebaseAuth.instance.currentUser?.uid,
          )
          .snapshots();

      return CombineLatestStream.combine2<
          QuerySnapshot<Map<String, dynamic>>,
          QuerySnapshot<Map<String, dynamic>>,
          List<QuerySnapshot<Map<String, dynamic>>>>(
        stream1,
        stream2,
        (firstStream, secondStream) => [firstStream, secondStream],
      );
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to load messages. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?> getUserInfo({
    required BuildContext context,
    required String userUid,
  }) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to load details. Please retry.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  static Future<bool> updateName({
    required BuildContext context,
    required String name,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'name': name});
      return true;
    } catch (e) {
      buildMaterialBanner(
        context: context,
        message: 'Failed to update name. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  static Future<bool> updatePhoneNumber({
    required BuildContext context,
  }) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
        smsCode: AuthModel.smsCode,
        verificationId: AuthModel.verificationId,
      );
      await FirebaseAuth.instance.currentUser?.updatePhoneNumber(
        phoneAuthCredential,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(
        {
          'phone_number': FirebaseAuth.instance.currentUser?.phoneNumber,
        },
      );
      return true;
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to update phone number. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  static Future<bool> updateProfileImage({
    required BuildContext context,
    required File? image,
  }) async {
    try {
      var imageUrl = '';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${FirebaseAuth.instance.currentUser?.uid}');

      if (image == null) {
        try {
          await storageRef.delete();
        } catch (_) {}
      } else {
        await storageRef.putFile(image);
        imageUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'profile_image_url': imageUrl});

      return true;
    } catch (e) {
      buildMaterialBanner(
        context: context,
        message: 'Failed to update profile image. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  static Future<void> saveContactsData({
    required BuildContext context,
  }) async {
    try {
      final status = await Permission.contacts.request();
      if (status != PermissionStatus.granted) {
        return;
      }

      final contacts = await ContactsService.getContacts();

      ContactsModel.registeredContacts.clear();
      ContactsModel.unregisteredContacts.clear();

      for (final contact in contacts) {
        final phoneNumber = PhoneNumberHelpers.removeSpaces(
          contact.phones?[0].value ?? '',
        );

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where(
              'phone_number',
              isEqualTo: phoneNumber,
            )
            .get();

        final exists = querySnapshot.docs.isNotEmpty;

        if (exists) {
          final user = querySnapshot.docs[0];
          final uid = user.id;
          final imageUrl = user.data()['profile_image_url'] as String;

          final image = imageUrl.isEmpty
              ? AssetImage('assets/images/default-profile-image.png')
              : NetworkImage(imageUrl) as ImageProvider;

          ContactsModel.registeredContacts.add(
            MyContact(
              name: contact.displayName ?? '',
              phoneNumber: phoneNumber,
              image: image,
              uid: uid,
            ),
          );
        } else {
          ContactsModel.unregisteredContacts.add(
            MyContact(
              name: contact.displayName ?? '',
              phoneNumber: phoneNumber,
              image: AssetImage('assets/images/default-profile-image.png'),
              uid: '',
            ),
          );
        }
      }

      ContactsModel.registeredContacts.sort(
        (contact1, contact2) => contact1.name.compareTo(contact2.name),
      );
      ContactsModel.unregisteredContacts.sort(
        (contact1, contact2) => contact1.name.compareTo(contact2.name),
      );
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to get contacts data. Please retry.',
        backgroundColor: kErrorColor,
      );
    }
  }

  static Future<void> setUserOnlineStatus(bool isOnline) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update(
        {
          'is_online': isOnline,
          'last_seen_timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
    } catch (_) {}
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>? getUserStream({
    required BuildContext context,
    required String userUid,
  }) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .snapshots();
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to load user info.',
        backgroundColor: kErrorColor,
      );
      return null;
    }
  }

  /// Todo: Complete the implementation of group chat feature
  static Future<bool> createGroup({
    required BuildContext context,
    required String name,
    required List<String> participantsUids,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('groups').add(
        {
          'name': name,
          'created_on': DateTime.now().millisecondsSinceEpoch,
          'created_by': FirebaseAuth.instance.currentUser?.uid,
          'admins': [
            FirebaseAuth.instance.currentUser?.uid,
          ],
          'participants': [
            FirebaseAuth.instance.currentUser?.uid,
            ...participantsUids,
          ],
          'message_docs': [],
        },
      );

      buildSnackBar(
        context: context,
        message: 'Group created successfully.',
        backgroundColor: kSuccessColor,
      );
      return true;
    } catch (e) {
      buildSnackBar(
        context: context,
        message: 'Failed to create group. Please retry.',
        backgroundColor: kErrorColor,
      );
      return false;
    }
  }

  /// Todo: Implement push notifications
// static Future<void> initializePushNotifications() async  {
//   await FirebaseMessaging.instance.requestPermission();
//
//   /// Triggered when notification is received while app is running
//   /// in the foreground
//   FirebaseMessaging.onMessage.listen(
//         (message) {
//       print('Got a message whilst in the foreground!');
//       if (message.notification != null) {
//         print('Message title: ${message.notification?.title}');
//         print('Message body: ${message.notification?.body}');
//       }
//     },
//   );
//
//   /// Triggered when notification is clicked when app is in
//   /// background / terminated
//   FirebaseMessaging.onBackgroundMessage(
//         (message) async {
//       print('Got a message whilst in the background!');
//       if (message.notification != null) {
//         print('Message title: ${message.notification?.title}');
//         print('Message body: ${message.notification?.body}');
//       }
//       return await Future<void>(() {});
//     },
//   );
//
//   await FirebaseMessaging.instance.subscribeToTopic('messages');
// }
}
