/// placeName : "placeName"
/// latitude : "latitude"
/// longitude : "longitude"
/// photoUrl : "photoUrl"
/// tripId : "tripId"
/// placeId : "placeId"

class SelectedPlaceModel {
  SelectedPlaceModel({
      String? placeName, 
      String? latitude, 
      String? longitude, 
      String? photoUrl, 
      String? tripId, 
      String? placeId,}){
    _placeName = placeName;
    _latitude = latitude;
    _longitude = longitude;
    _photoUrl = photoUrl;
    _tripId = tripId;
    _placeId = placeId;
}

  SelectedPlaceModel.fromJson(dynamic json) {
    _placeName = json['placeName'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _photoUrl = json['photoUrl'];
    _tripId = json['tripId'];
    _placeId = json['placeId'];
  }
  String? _placeName;
  String? _latitude;
  String? _longitude;
  String? _photoUrl;
  String? _tripId;
  String? _placeId;
SelectedPlaceModel copyWith({  String? placeName,
  String? latitude,
  String? longitude,
  String? photoUrl,
  String? tripId,
  String? placeId,
}) => SelectedPlaceModel(  placeName: placeName ?? _placeName,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  photoUrl: photoUrl ?? _photoUrl,
  tripId: tripId ?? _tripId,
  placeId: placeId ?? _placeId,
);
  String? get placeName => _placeName;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get photoUrl => _photoUrl;
  String? get tripId => _tripId;
  String? get placeId => _placeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['placeName'] = _placeName;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['photoUrl'] = _photoUrl;
    map['tripId'] = _tripId;
    map['placeId'] = _placeId;
    return map;
  }

}