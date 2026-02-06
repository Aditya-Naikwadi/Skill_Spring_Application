import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  student,
  instructor,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

class UserModel {
  final String uid;
  final String email;
  final String? phoneNumber;
  final String displayName;
  final UserRole role;
  final String institution;
  final List<String> enrolledCourses;
  final List<String> completedCourses;
  final int points;
  final int rank;
  final String? profilePictureUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    this.phoneNumber,
    required this.displayName,
    required this.role,
    required this.institution,
    this.enrolledCourses = const [],
    this.completedCourses = const [],
    this.points = 0,
    this.rank = 0,
    this.profilePictureUrl,
    required this.createdAt,
    required this.lastLoginAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'role': role.name,
      'institution': institution,
      'enrolledCourses': enrolledCourses,
      'completedCourses': completedCourses,
      'points': points,
      'rank': rank,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      displayName: map['displayName'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.student,
      ),
      institution: map['institution'] ?? '',
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      completedCourses: List<String>.from(map['completedCourses'] ?? []),
      points: map['points'] ?? 0,
      rank: map['rank'] ?? 0,
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? email,
    String? phoneNumber,
    String? displayName,
    UserRole? role,
    String? institution,
    List<String>? enrolledCourses,
    List<String>? completedCourses,
    int? points,
    int? rank,
    String? profilePictureUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      institution: institution ?? this.institution,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      completedCourses: completedCourses ?? this.completedCourses,
      points: points ?? this.points,
      rank: rank ?? this.rank,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
