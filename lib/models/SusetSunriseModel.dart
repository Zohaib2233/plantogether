/// results : {"date":"2024-02-29","sunrise":"11:44:22 AM","sunset":"11:00:09 PM","first_light":"10:15:48 AM","last_light":"12:28:43 AM","dawn":"11:17:34 AM","dusk":"11:26:58 PM","solar_noon":"5:22:16 PM","golden_hour":"10:24:09 PM","day_length":"11:15:47","timezone":"UTC","utc_offset":0}
/// status : "OK"

class SusetSunriseModel {
  SusetSunriseModel({
      Results? results, 
      String? status,}){
    _results = results;
    _status = status;
}

  SusetSunriseModel.fromJson(dynamic json) {
    _results = json['results'] != null ? Results.fromJson(json['results']) : null;
    _status = json['status'];
  }
  Results? _results;
  String? _status;
SusetSunriseModel copyWith({  Results? results,
  String? status,
}) => SusetSunriseModel(  results: results ?? _results,
  status: status ?? _status,
);
  Results? get results => _results;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_results != null) {
      map['results'] = _results?.toJson();
    }
    map['status'] = _status;
    return map;
  }

}

/// date : "2024-02-29"
/// sunrise : "11:44:22 AM"
/// sunset : "11:00:09 PM"
/// first_light : "10:15:48 AM"
/// last_light : "12:28:43 AM"
/// dawn : "11:17:34 AM"
/// dusk : "11:26:58 PM"
/// solar_noon : "5:22:16 PM"
/// golden_hour : "10:24:09 PM"
/// day_length : "11:15:47"
/// timezone : "UTC"
/// utc_offset : 0

class Results {
  Results({
      String? date, 
      String? sunrise, 
      String? sunset, 
      String? firstLight, 
      String? lastLight, 
      String? dawn, 
      String? dusk, 
      String? solarNoon, 
      String? goldenHour, 
      String? dayLength, 
      String? timezone, 
      num? utcOffset,}){
    _date = date;
    _sunrise = sunrise;
    _sunset = sunset;
    _firstLight = firstLight;
    _lastLight = lastLight;
    _dawn = dawn;
    _dusk = dusk;
    _solarNoon = solarNoon;
    _goldenHour = goldenHour;
    _dayLength = dayLength;
    _timezone = timezone;
    _utcOffset = utcOffset;
}

  Results.fromJson(dynamic json) {
    _date = json['date'];
    _sunrise = json['sunrise'];
    _sunset = json['sunset'];
    _firstLight = json['first_light'];
    _lastLight = json['last_light'];
    _dawn = json['dawn'];
    _dusk = json['dusk'];
    _solarNoon = json['solar_noon'];
    _goldenHour = json['golden_hour'];
    _dayLength = json['day_length'];
    _timezone = json['timezone'];
    _utcOffset = json['utc_offset'];
  }
  String? _date;
  String? _sunrise;
  String? _sunset;
  String? _firstLight;
  String? _lastLight;
  String? _dawn;
  String? _dusk;
  String? _solarNoon;
  String? _goldenHour;
  String? _dayLength;
  String? _timezone;
  num? _utcOffset;
Results copyWith({  String? date,
  String? sunrise,
  String? sunset,
  String? firstLight,
  String? lastLight,
  String? dawn,
  String? dusk,
  String? solarNoon,
  String? goldenHour,
  String? dayLength,
  String? timezone,
  num? utcOffset,
}) => Results(  date: date ?? _date,
  sunrise: sunrise ?? _sunrise,
  sunset: sunset ?? _sunset,
  firstLight: firstLight ?? _firstLight,
  lastLight: lastLight ?? _lastLight,
  dawn: dawn ?? _dawn,
  dusk: dusk ?? _dusk,
  solarNoon: solarNoon ?? _solarNoon,
  goldenHour: goldenHour ?? _goldenHour,
  dayLength: dayLength ?? _dayLength,
  timezone: timezone ?? _timezone,
  utcOffset: utcOffset ?? _utcOffset,
);
  String? get date => _date;
  String? get sunrise => _sunrise;
  String? get sunset => _sunset;
  String? get firstLight => _firstLight;
  String? get lastLight => _lastLight;
  String? get dawn => _dawn;
  String? get dusk => _dusk;
  String? get solarNoon => _solarNoon;
  String? get goldenHour => _goldenHour;
  String? get dayLength => _dayLength;
  String? get timezone => _timezone;
  num? get utcOffset => _utcOffset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['sunrise'] = _sunrise;
    map['sunset'] = _sunset;
    map['first_light'] = _firstLight;
    map['last_light'] = _lastLight;
    map['dawn'] = _dawn;
    map['dusk'] = _dusk;
    map['solar_noon'] = _solarNoon;
    map['golden_hour'] = _goldenHour;
    map['day_length'] = _dayLength;
    map['timezone'] = _timezone;
    map['utc_offset'] = _utcOffset;
    return map;
  }

}