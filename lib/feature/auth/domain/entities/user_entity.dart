import 'package:equatable/equatable.dart';

/// Entity of user for only showing or exposing required properties that's used
class UserEntity extends Equatable {
  /// Creates an instance of userEntity
  const UserEntity({
    this.uid,
    this.email,
    this.name,
    this.surname,
    this.profilePicture,
  });

  /// Unique user id
  final String? uid;

  /// User name
  final String? name;

  /// User surname
  final String? surname;

  /// User email
  final String? email;

  /// User profile picture URL
  final String? profilePicture;

  @override
  List<Object?> get props => <Object?>[
    uid,
    email,
    name,
    surname,
    profilePicture,
  ];

  /// Copy with method for entity
  UserEntity copyWith({
    final String? uid,
    final String? name,
    final String? surname,
    final String? email,
    final String? profilePicture,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
