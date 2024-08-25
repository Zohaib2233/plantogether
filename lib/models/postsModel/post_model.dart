import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String createdBy;
  final String description;
  final List<String> imageUrls;
  final int totalLikes;
  final int totalComments;
  final List<String> likes;
  final int rate;
  final DateTime dateTime;
  final String createrProfile;
  final String createrName;
  final String tripId; // New field

  PostModel({
    required this.postId,
    required this.createdBy,
    required this.description,
    required this.imageUrls,
    required this.totalLikes,
    required this.totalComments,
    required this.likes,
    required this.rate,
    required this.dateTime,
    required this.createrProfile,
    required this.createrName,
    required this.tripId, // Initialize with null
  });

  // Convert PostModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'createdBy': createdBy,
      'description': description,
      'imageUrls': imageUrls,
      'totalLikes': totalLikes,
      'totalComments': totalComments,
      'likes': likes,
      'rate': rate,
      'dateTime': dateTime,
      'createrProfile': createrProfile,
      'createrName': createrName,
      'tripId': tripId, // Include tripId in the map
    };
  }

  // Create PostModel from a Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'],
      createdBy: map['createdBy'],
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls']),
      totalLikes: map['totalLikes'],
      totalComments: map['totalComments'],
      likes: List<String>.from(map['likes']),
      rate: map['rate'],
      dateTime: (map['dateTime'] as Timestamp).toDate(),
      createrProfile: map['createrProfile'],
      createrName: map['createrName'],
      tripId: map['tripId'], // Retrieve tripId from Firestore
    );
  }
}
