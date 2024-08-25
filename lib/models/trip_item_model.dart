class TripItemModel {
  TripItemModel({
    this.addedBy,
    this.item,
    this.selected,
    this.email,
    this.docId,
  });

  String? addedBy;
  String? item;
  bool? selected;
  String? email;
  String? docId;

  TripItemModel.fromJson(Map<String, dynamic> json) {
    addedBy = json['addedBy'];
    item = json['item'];
    selected = json['selected'];
    email = json['email'];
    docId = json['docId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['addedBy'] = addedBy;
    data['item'] = item;
    data['selected'] = selected;
    data['email'] = email;
    data['docId'] = docId;
    return data;
  }

  TripItemModel copyWith({
    String? addedBy,
    String? item,
    bool? selected,
    String? email,
    String? docId,
  }) {
    return TripItemModel(
      addedBy: addedBy ?? this.addedBy,
      item: item ?? this.item,
      selected: selected ?? this.selected,
      email: email ?? this.email,
      docId: docId ?? this.docId,
    );
  }
}
