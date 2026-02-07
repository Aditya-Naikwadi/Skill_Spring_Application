import 'package:cloud_firestore/cloud_firestore.dart';

class CertificateModel {
  final String id;
  final String userId;
  final String userName;
  final String courseId;
  final String courseTitle;
  final String certificateUrl;
  final DateTime issuedAt;

  CertificateModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.courseId,
    required this.courseTitle,
    required this.certificateUrl,
    required this.issuedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'certificateUrl': certificateUrl,
      'issuedAt': Timestamp.fromDate(issuedAt),
    };
  }

  factory CertificateModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CertificateModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      courseId: data['courseId'] ?? '',
      courseTitle: data['courseTitle'] ?? '',
      certificateUrl: data['certificateUrl'] ?? '',
      issuedAt: (data['issuedAt'] as Timestamp).toDate(),
    );
  }
}
