import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseName;
  final String userName;
  final DateTime issueDate;
  final String certificateUrl;
  final String verificationCode;
  final double completionScore;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseName,
    required this.userName,
    required this.issueDate,
    required this.certificateUrl,
    required this.verificationCode,
    this.completionScore = 100.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'courseName': courseName,
      'userName': userName,
      'issueDate': Timestamp.fromDate(issueDate),
      'certificateUrl': certificateUrl,
      'verificationCode': verificationCode,
      'completionScore': completionScore,
    };
  }

  factory CertificateModel.fromMap(Map<String, dynamic> map) {
    return CertificateModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      userName: map['userName'] ?? '',
      issueDate: (map['issueDate'] as Timestamp).toDate(),
      certificateUrl: map['certificateUrl'] ?? '',
      verificationCode: map['verificationCode'] ?? '',
      completionScore: (map['completionScore'] ?? 100.0).toDouble(),
    );
  }
}
