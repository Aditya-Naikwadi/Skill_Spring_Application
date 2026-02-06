import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardEntry {
  final String userId;
  final String userName;
  final String? profilePictureUrl;
  final String institution;
  final int points;
  final int rank;
  final int coursesCompleted;
  final int projectsCompleted;
  final List<String> badges;
  final DateTime lastUpdated;

  LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.profilePictureUrl,
    required this.institution,
    required this.points,
    required this.rank,
    this.coursesCompleted = 0,
    this.projectsCompleted = 0,
    this.badges = const [],
    required this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profilePictureUrl': profilePictureUrl,
      'institution': institution,
      'points': points,
      'rank': rank,
      'coursesCompleted': coursesCompleted,
      'projectsCompleted': projectsCompleted,
      'badges': badges,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      profilePictureUrl: map['profilePictureUrl'],
      institution: map['institution'] ?? '',
      points: map['points'] ?? 0,
      rank: map['rank'] ?? 0,
      coursesCompleted: map['coursesCompleted'] ?? 0,
      projectsCompleted: map['projectsCompleted'] ?? 0,
      badges: List<String>.from(map['badges'] ?? []),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }
}
