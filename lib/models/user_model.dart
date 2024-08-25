import 'package:plan_together/utils/app_strings.dart';

class UserModel {
  UserModel({
    String? id,
    String? name,deviceToken,
    String? username,
    String? email,
    String? countryCode,
    String? password,
    String? localCurrency,
    String? country,
    String? profileImgUrl,
    String? bgImgUrl = '',
    String? status = AppStrings.offline,
    String? currencyCode,
    int tripCount = 0,
    int totalFollowers = 0,
    int totalFollowing = 0,
    List<String>? followers,
    List<String>? following,
    List<String>? bookmarkPosts, // New field
  }) {
    _id = id;
    _name = name;
    _deviceToken = deviceToken;
    _username = username;
    _email = email;
    _countryCode = countryCode;
    _password = password;
    _localCurrency = localCurrency;
    _country = country;
    _profileImgUrl = profileImgUrl;
    _bgImgUrl = bgImgUrl;
    _status = status;
    _currencyCode = currencyCode;
    _tripCount = tripCount;
    _totalFollowers = totalFollowers;
    _totalFollowing = totalFollowing;
    _followers = followers ?? [];
    _following = following ?? [];
    _bookmarkPosts = bookmarkPosts ?? []; // Initialize with an empty list if not provided
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _deviceToken = json['deviceToken']??'';
    _username = json['username'];
    _email = json['email'];
    _countryCode = json['countryCode'];
    _password = json['password'];
    _localCurrency = json['localCurrency'];
    _country = json['country'];
    _profileImgUrl = json['profileImgUrl'];
    _bgImgUrl = json['bgImgUrl'];
    _status = json['status'];
    _currencyCode = json['currencyCode'];
    _tripCount = json['tripCount'] ?? 0;
    _totalFollowers = json['totalFollowers'] ?? 0;
    _totalFollowing = json['totalFollowing'] ?? 0;
    _followers = List<String>.from(json['followers'] ?? []);
    _following = List<String>.from(json['following'] ?? []);
    _bookmarkPosts = List<String>.from(json['bookmarkPosts'] ?? []); // Retrieve bookmarkPosts from Firestore
  }

  String? _id;
  String? _name;
  String? _deviceToken;
  String? _username;
  String? _email;
  String? _countryCode;
  String? _password;
  String? _localCurrency;
  String? _country;
  String? _profileImgUrl;
  String? _bgImgUrl;
  String? _status;
  String? _currencyCode;
  int _tripCount = 0;
  int _totalFollowers = 0;
  int _totalFollowing = 0;
  List<String> _followers = [];
  List<String> _following = [];
  List<String> _bookmarkPosts = [];

  UserModel copyWith({
    String? id,
    String? name,
    String? deviceToken,
    String? username,
    String? email,
    String? countryCode,
    String? password,
    String? localCurrency,
    String? country,
    String? profileImgUrl,
    String? bgImgUrl,
    String? status,
    String? currencyCode,
    int? tripCount,
    int? totalFollowers,
    int? totalFollowing,
    List<String>? followers,
    List<String>? following,
    List<String>? bookmarkPosts,
  }) =>
      UserModel(
        id: id ?? _id,
        name: name ?? _name,
        deviceToken: deviceToken ?? _deviceToken,
        username: username ?? _username,
        email: email ?? _email,
        countryCode: countryCode ?? _countryCode,
        password: password ?? _password,
        localCurrency: localCurrency ?? _localCurrency,
        country: country ?? _country,
        profileImgUrl: profileImgUrl ?? _profileImgUrl,
        bgImgUrl: bgImgUrl ?? _bgImgUrl,
        status: status ?? _status,
        currencyCode: currencyCode ?? _currencyCode,
        tripCount: tripCount ?? _tripCount,
        totalFollowers: totalFollowers ?? _totalFollowers,
        totalFollowing: totalFollowing ?? _totalFollowing,
        followers: followers ?? _followers,
        following: following ?? _following,
        bookmarkPosts: bookmarkPosts ?? _bookmarkPosts,
      );

  String? get id => _id;
  String? get name => _name;
  String? get deviceToken => _deviceToken;
  String? get username => _username;
  String? get email => _email;
  String? get countryCode => _countryCode;
  String? get password => _password;
  String? get localCurrency => _localCurrency;
  String? get country => _country;
  String? get profileImgUrl => _profileImgUrl;
  String? get bgImgUrl => _bgImgUrl;
  String? get status => _status;
  String? get currencyCode => _currencyCode;
  int get tripCount => _tripCount;
  int get totalFollowers => _totalFollowers;
  int get totalFollowing => _totalFollowing;
  List<String> get followers => _followers;
  List<String> get following => _following;
  List<String> get bookmarkPosts => _bookmarkPosts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['deviceToken'] = _deviceToken;
    map['username'] = _username;
    map['email'] = _email;
    map['countryCode'] = _countryCode;
    map['password'] = _password;
    map['localCurrency'] = _localCurrency;
    map['country'] = _country;
    map['profileImgUrl'] = _profileImgUrl;
    map['bgImgUrl'] = _bgImgUrl;
    map['status'] = _status;
    map['currencyCode'] = _currencyCode;
    map['tripCount'] = _tripCount;
    map['totalFollowers'] = _totalFollowers;
    map['totalFollowing'] = _totalFollowing;
    map['followers'] = _followers;
    map['following'] = _following;
    map['bookmarkPosts'] = _bookmarkPosts;
    return map;
  }
}
