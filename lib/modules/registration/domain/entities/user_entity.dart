import 'dart:convert';

class UserEntity {
  final String? uid;
  final String name;
  final String email;
  final String? circleCode;
  final String phone;
  final String? photoUrl;
  final String? pinUrl;
  final double? latitude;
  final double? longitude;

  UserEntity({
    this.uid,
    required this.name,
    required this.email,
    this.circleCode,
    required this.phone,
    required this.photoUrl,
    this.pinUrl,
    this.latitude,
    this.longitude,
  });

  UserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? circleCode,
    String? phone,
    String? photoUrl,
    String? pinUrl,
    double? latitude,
    double? longitude,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      circleCode: circleCode ?? this.circleCode,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      pinUrl: pinUrl ?? this.pinUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'circleCode': circleCode,
      'phone': phone,
      'photoUrl': photoUrl,
      'pinUrl': pinUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      circleCode: map['circleCode'],
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'],
      pinUrl: map['pinUrl'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  factory UserEntity.empty() {
    return UserEntity(
      uid: null,
      name: '',
      email: '',
      circleCode: '',
      phone: '',
      photoUrl: '',
      pinUrl: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, email: $email, circleCode: $circleCode, phone: $phone, photoUrl: $photoUrl, pinUrl: $pinUrl, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.circleCode == circleCode &&
        other.phone == phone &&
        other.photoUrl == photoUrl &&
        other.pinUrl == pinUrl &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        circleCode.hashCode ^
        phone.hashCode ^
        photoUrl.hashCode ^
        pinUrl.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
