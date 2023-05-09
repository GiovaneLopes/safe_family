import 'dart:convert';

class UserEntity {
  final String? uid;
  final String name;
  final String email;
  final String? circleCode;
  final String phone;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;

  UserEntity({
    this.uid,
    required this.name,
    required this.email,
    this.circleCode,
    required this.phone,
    required this.photoUrl,
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
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'circle-code': circleCode,
      'phone': phone,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      circleCode: map['circle-code'],
      phone: map['phone'] ?? '',
      photoUrl: map['photo-url'] ?? '',
      latitude: map['latitude'] ?? 0,
      longitude: map['longitude'] ?? 0,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEntity.fromJson(String source) =>
      UserEntity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserEntity(uid: $uid, name: $name, email: $email, circleCode: $circleCode, phone: $phone, photoUrl: $photoUrl)';
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
        latitude.hashCode ^
        longitude.hashCode;
  }
}
