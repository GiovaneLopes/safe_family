import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:safe_lopes_family/modules/registration/domain/entities/user_entity.dart';

class CircleEntity {
  final String code;
  final List<UserEntity> users;

  CircleEntity({
    required this.code,
    required this.users,
  });

  CircleEntity copyWith({
    String? code,
    List<UserEntity>? users,
  }) {
    return CircleEntity(
      code: code ?? this.code,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'users': users,
    };
  }

  factory CircleEntity.fromMap(Map<String, dynamic> map) {
    return CircleEntity(
      code: map['code'] ?? '',
      users: List<UserEntity>.from(map['users']),
    );
  }

  factory CircleEntity.empty() {
    return CircleEntity(code: '', users: []);
  }

  String toJson() => json.encode(toMap());

  factory CircleEntity.fromJson(String source) =>
      CircleEntity.fromMap(json.decode(source));

  @override
  String toString() => 'CircleEntity(code: $code, users: $users)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CircleEntity &&
        other.code == code &&
        listEquals(other.users, users);
  }

  @override
  int get hashCode => code.hashCode ^ users.hashCode;
}
