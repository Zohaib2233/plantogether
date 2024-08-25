import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? message;
  DateTime? sentAt;
  String? sentBy;
  String? messageId;
  bool? seenBySender;
  bool? seenByReceiver;

  MessageModel({
    this.sentBy,
    this.sentAt,
    this.message,
    this.messageId,
    this.seenBySender,
    this.seenByReceiver,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message ?? '',
      'sentAt': sentAt ?? DateTime.now(),
      'sentBy': sentBy ?? '',
      'messageId': messageId ?? '',
      'seenBySender': seenBySender ?? false,
      'seenByReceiver': seenByReceiver ?? false,
    };
  }

  factory MessageModel.fromJson1(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'],
      sentBy: map['sentBy'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      seenBySender: map['seenBySender'] ?? false,
      seenByReceiver: map['seenByReceiver'] ?? false,
    );
  }

  factory MessageModel.fromJson2(DocumentSnapshot map) {
    return MessageModel(
      message: map['message'],
      sentBy: map['sentBy'],
      sentAt: (map['sentAt'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      seenBySender: map['seenBySender'] ?? false,
      seenByReceiver: map['seenByReceiver'] ?? false,
    );
  }
}
