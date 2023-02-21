import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatHelpers {
  static List<DateTime> extractUniqueDates(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final uniqueDates = <DateTime>[];
    for (final doc in docs) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
        doc.data()['timestamp'] as int,
      );
      final date = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );
      if (!uniqueDates.contains(date)) {
        uniqueDates.add(date);
      }
    }
    uniqueDates.sort((a, b) => b.compareTo(a));
    return uniqueDates;
  }

  static List<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      extractMessageGroups(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<DateTime> uniqueDates,
  ) {
    final messageGroups = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    for (final uniqueDate in uniqueDates) {
      final group = sortDocsByDateTime(
        docs.where(
          (doc) {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(
              doc.data()['timestamp'] as int,
            );
            return dateTime.year == uniqueDate.year &&
                dateTime.month == uniqueDate.month &&
                dateTime.day == uniqueDate.day;
          },
        ).toList(),
      );
      messageGroups.add(group);
    }
    return messageGroups;
  }

  static List<String> extractUserUids(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final userUids = <String>[];
    for (final doc in docs) {
      final senderUid = doc.get('sender_uid') as String;
      final receiverUid = doc.get('receiver_uid') as String;
      final me = FirebaseAuth.instance.currentUser?.uid;
      if (senderUid != me && !userUids.contains(senderUid)) {
        userUids.add(senderUid);
      } else if (receiverUid != me && !userUids.contains(receiverUid)) {
        userUids.add(receiverUid);
      }
    }
    return userUids;
  }

  static List<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _extractChatGroups(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<String> userUids,
  ) {
    final chatGroups = <List<QueryDocumentSnapshot<Map<String, dynamic>>>>[];
    for (final userUid in userUids) {
      final group = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
      for (final doc in docs) {
        final senderUid = doc.get('sender_uid') as String;
        final receiverUid = doc.get('receiver_uid') as String;
        if (userUid == senderUid || userUid == receiverUid) {
          group.add(doc);
        }
      }
      chatGroups.add(group);
    }
    return chatGroups;
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>>
      extractLatestMessagesGroupWise(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    List<String> userUids,
  ) {
    final chatGroups = _extractChatGroups(docs, userUids);
    final latestMessages = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    for (final chatGroup in chatGroups) {
      latestMessages.add(
        sortDocsByDateTime(chatGroup, descending: true)[0],
      );
    }
    return latestMessages;
  }

  static List<QueryDocumentSnapshot<Map<String, dynamic>>> sortDocsByDateTime(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    bool descending = false,
  }) {
    return docs
      ..sort(
        (doc1, doc2) {
          final dateTime1 = DateTime.fromMillisecondsSinceEpoch(
            doc1.data()['timestamp'] as int,
          );
          final dateTime2 = DateTime.fromMillisecondsSinceEpoch(
            doc2.data()['timestamp'] as int,
          );
          return descending
              ? dateTime2.compareTo(dateTime1)
              : dateTime1.compareTo(dateTime2);
        },
      );
  }
}
