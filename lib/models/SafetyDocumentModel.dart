import 'package:cloud_firestore/cloud_firestore.dart';

class SafetyDocumentModel {
  final String docId;
  final String tripId;
  final String title;
  final DateTime time;
  final String documentUrl;
  final bool isPublic;
  final String addedBy;

  SafetyDocumentModel({
    required this.docId,
    required this.tripId,
    required this.title,
    DateTime? time,
    required this.documentUrl,
    required this.isPublic,
    required this.addedBy,
  }):time = time??DateTime.now();

  factory SafetyDocumentModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SafetyDocumentModel(
      docId: snapshot.id,
      tripId: data['tripId'] ?? '',
      title: data['title'] ?? '',
      time: (data['time'] as Timestamp).toDate(),
      documentUrl: data['documentUrl'] ?? '',
      isPublic: data['isPublic'] ?? false,
      addedBy: data['addedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'title': title,
      'time': time,
      'documentUrl': documentUrl,
      'isPublic': isPublic,
      'addedBy': addedBy,
    };
  }
}
