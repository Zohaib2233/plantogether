import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  String? tripId;
  String? docId;
  String? tripName;
  String? startDate;
  String? endDate;
  DateTime? tripStartDate;
  DateTime? tripEndDate;
  List<String>? addTravelers;
  List<String>? names;
  List<String>? usersId;
  List<String>? destination;
  List<String>? profileUrls;
  String? travlling;
  List<String>? postsBy;

  TripModel({
    this.tripId,
    this.docId,
    this.tripName,
    this.startDate,
    this.endDate,
    this.tripStartDate,
    this.tripEndDate,
    this.addTravelers,
    this.names,
    this.usersId,
    this.destination,
    this.profileUrls,
    this.travlling,
    this.postsBy,
  });

  TripModel.fromJson(dynamic json) {
    tripId = json['tripId'];
    docId = json['docId'];
    tripName = json['tripName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    tripStartDate = json['tripStartDate'] != null ? (json['tripStartDate'] as Timestamp).toDate() : null;
    tripEndDate = json['tripEndDate'] != null ? (json['tripEndDate'] as Timestamp).toDate() : null;
    addTravelers = json['addTravelers'] != null ? List<String>.from(json['addTravelers']) : null;
    names = json['names'] != null ? List<String>.from(json['names']) : null;
    usersId = json['usersId'] != null ? List<String>.from(json['usersId']) : null;
    destination = json['destination'] != null ? List<String>.from(json['destination']) : null;
    profileUrls = json['profileUrls'] != null ? List<String>.from(json['profileUrls']) : null;
    travlling = json['travlling'];
    postsBy = json['postsBy'] != null ? List<String>.from(json['postsBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tripId'] = tripId;
    data['docId'] = docId;
    data['tripName'] = tripName;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['tripStartDate'] = tripStartDate != null ? Timestamp.fromDate(tripStartDate!) : null;
    data['tripEndDate'] = tripEndDate != null ? Timestamp.fromDate(tripEndDate!) : null;
    data['addTravelers'] = addTravelers;
    data['names'] = names;
    data['usersId'] = usersId;
    data['destination'] = destination;
    data['profileUrls'] = profileUrls;
    data['travlling'] = travlling;
    data['postsBy'] = postsBy??<String>[];
    return data;
  }
}
