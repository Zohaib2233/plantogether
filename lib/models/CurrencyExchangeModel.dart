/// success : true
/// query : {"from":"USD","to":"PKR","amount":750}
/// info : {"timestamp":1709188143,"rate":278.764117}
/// date : "2024-02-29"
/// result : 209073.08775

class CurrencyExchangeModel {
  CurrencyExchangeModel({
      bool? success, 
      Query? query, 
      Info? info, 
      String? date, 
      num? result,}){
    _success = success;
    _query = query;
    _info = info;
    _date = date;
    _result = result;
}

  CurrencyExchangeModel.fromJson(dynamic json) {
    _success = json['success'];
    _query = json['query'] != null ? Query.fromJson(json['query']) : null;
    _info = json['info'] != null ? Info.fromJson(json['info']) : null;
    _date = json['date'] as String;
    _result = json['result'];
  }
  bool? _success;
  Query? _query;
  Info? _info;
  String? _date;
  num? _result;
CurrencyExchangeModel copyWith({  bool? success,
  Query? query,
  Info? info,
  String? date,
  num? result,
}) => CurrencyExchangeModel(  success: success ?? _success,
  query: query ?? _query,
  info: info ?? _info,
  date: date ?? _date,
  result: result ?? _result,
);
  bool? get success => _success;
  Query? get query => _query;
  Info? get info => _info;
  String? get date => _date;
  num? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_query != null) {
      map['query'] = _query?.toJson();
    }
    if (_info != null) {
      map['info'] = _info?.toJson();
    }
    map['date'] = _date;
    map['result'] = _result;
    return map;
  }

}

/// timestamp : 1709188143
/// rate : 278.764117

class Info {
  Info({
      num? timestamp, 
      num? rate,}){
    _timestamp = timestamp;
    _rate = rate;
}

  Info.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _rate = json['rate'];
  }
  num? _timestamp;
  num? _rate;
Info copyWith({  num? timestamp,
  num? rate,
}) => Info(  timestamp: timestamp ?? _timestamp,
  rate: rate ?? _rate,
);
  num? get timestamp => _timestamp;
  num? get rate => _rate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['rate'] = _rate;
    return map;
  }

}

/// from : "USD"
/// to : "PKR"
/// amount : 750

class Query {
  Query({
      String? from, 
      String? to, 
      num? amount,}){
    _from = from;
    _to = to;
    _amount = amount;
}

  Query.fromJson(dynamic json) {
    _from = json['from'];
    _to = json['to'];
    _amount = json['amount'];
  }
  String? _from;
  String? _to;
  num? _amount;
Query copyWith({  String? from,
  String? to,
  num? amount,
}) => Query(  from: from ?? _from,
  to: to ?? _to,
  amount: amount ?? _amount,
);
  String? get from => _from;
  String? get to => _to;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['from'] = _from;
    map['to'] = _to;
    map['amount'] = _amount;
    return map;
  }

}