import 'package:cloud_firestore/cloud_firestore.dart';


class GroupBudgetModel {
  String? addedBy;
  String? tripId;
  DateTime? time;
  double? amount;
  String? gbId;
  List<String>? travellers;
  List<String>? images;
  bool? expenseAdded;

  GroupBudgetModel({
    this.addedBy,
    this.tripId,
    this.time,
    this.amount,
    this.gbId,
    this.travellers,
    this.images,
    this.expenseAdded,
  });

  factory GroupBudgetModel.fromJson(Map<String, dynamic> json) {
    return GroupBudgetModel(
      addedBy: json['addedBy'],
      tripId: json['tripId'],
      time: (json['time'] as Timestamp).toDate(),
      amount: json['amount']?.toDouble(),
      gbId: json['gbId'],
      travellers: List<String>.from(json['travellers'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      expenseAdded: json['expenseAdded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addedBy": addedBy,
      "tripId": tripId,
      "time": time,
      "amount": amount,
      "gbId": gbId,
      "travellers": travellers,
      "images": images,
      "expenseAdded": expenseAdded,
    };
  }
}
