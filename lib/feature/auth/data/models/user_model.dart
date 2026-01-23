import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_scanner_practice/feature/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.uid,
    super.email,
    super.name,
    super.surname,
    super.profilePicture,
  });

  factory UserModel.fromFirebaseUser(final User user) {
    final String fullName =
        user.displayName ?? user.email?.split('@').first ?? '';
    final List<String> nameParts = fullName.split(' ');

    final String name = nameParts.isNotEmpty ? nameParts.first : '';
    final String surname = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : '';

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: name,
      surname: surname,
      profilePicture: user.photoURL ?? '',
    );
  }

  factory UserModel.fromJson(final Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'uid': uid ?? '',
    'email': email ?? '',
    'name': name ?? '',
    'surname': surname ?? '',
    'profilePicture': profilePicture ?? '',
  };

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      surname: surname,
      profilePicture: profilePicture,
    );
  }

  factory UserModel.fromEntity(final UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      name: entity.name,
      surname: entity.surname,
      profilePicture: entity.profilePicture,
    );
  }
}
