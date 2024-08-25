/// docId : ""
/// name : ""
/// phoneNumber : ""
/// isPublic : true
/// tripId : ""
/// addedBy : ""

class SafetyPhoneNumberModel {
  SafetyPhoneNumberModel({
      String? docId, 
      String? name, 
      String? phoneNumber, 
      bool? isPublic, 
      String? tripId, 
      String? addedBy,}){
    _docId = docId;
    _name = name;
    _phoneNumber = phoneNumber;
    _isPublic = isPublic;
    _tripId = tripId;
    _addedBy = addedBy;
}

  SafetyPhoneNumberModel.fromJson(dynamic json) {
    _docId = json['docId'];
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _isPublic = json['isPublic'];
    _tripId = json['tripId'];
    _addedBy = json['addedBy'];
  }
  String? _docId;
  String? _name;
  String? _phoneNumber;
  bool? _isPublic;
  String? _tripId;
  String? _addedBy;
SafetyPhoneNumberModel copyWith({  String? docId,
  String? name,
  String? phoneNumber,
  bool? isPublic,
  String? tripId,
  String? addedBy,
}) => SafetyPhoneNumberModel(  docId: docId ?? _docId,
  name: name ?? _name,
  phoneNumber: phoneNumber ?? _phoneNumber,
  isPublic: isPublic ?? _isPublic,
  tripId: tripId ?? _tripId,
  addedBy: addedBy ?? _addedBy,
);
  String? get docId => _docId;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  bool? get isPublic => _isPublic;
  String? get tripId => _tripId;
  String? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['docId'] = _docId;
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['isPublic'] = _isPublic;
    map['tripId'] = _tripId;
    map['addedBy'] = _addedBy;
    return map;
  }

}