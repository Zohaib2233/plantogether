import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String postId;
  final String commentId;
  final DateTime date;
  final String commentMsg; // New field
  final String commentorName;
  final String commentorProfile;
  final String commentorUid;

  CommentModel({
    required this.postId,
    required this.commentId,
    required this.date,
    required this.commentMsg, // Initialize new field
    required this.commentorName,
    required this.commentorProfile,
    required this.commentorUid,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: json['postId'],
      commentId: json['commentId'],
      date: (json['date'] as Timestamp).toDate(),
      commentMsg: json['commentMsg'], // Assign value to new field
      commentorName: json['commentorName'],
      commentorProfile: json['commentorProfile'],
      commentorUid: json['commentorUid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'commentId': commentId,
      'date': date,
      'commentMsg': commentMsg, // Include new field in JSON
      'commentorName': commentorName,
      'commentorProfile': commentorProfile,
      'commentorUid': commentorUid,
    };
  }
}
