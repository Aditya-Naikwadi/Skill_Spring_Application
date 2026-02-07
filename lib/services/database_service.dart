import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/certificate_model.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _coursesCollection => _firestore.collection('courses');
  CollectionReference get _certificatesCollection => _firestore.collection('certificates');
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Get Courses Stream
  Stream<List<CourseModel>> getCourses(String category) {
    Query query = _coursesCollection.orderBy('createdAt', descending: true);

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CourseModel.fromSnapshot(doc)).toList();
    });
  }

  // Seed Initial Data (Run this once)
  Future<void> seedInitialCourses() async {
    final snapshot = await _coursesCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already seeded

    final List<Map<String, dynamic>> initialCourses = [
      {
        'title': 'Python for Beginners',
        'description': 'Learn Python programming from scratch with hands-on projects',
        'category': 'Development',
        'difficulty': 'Beginner',
        'duration': '8 weeks',
        'enrolledCount': 1200,
        'iconCode': Icons.code.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      {
        'title': 'Web Development Bootcamp',
        'description': 'Master HTML, CSS, JavaScript and build real-world websites',
        'category': 'Development',
        'difficulty': 'Intermediate',
        'duration': '12 weeks',
        'enrolledCount': 2500,
        'iconCode': Icons.web.codePoint.toString(),
        'createdAt': DateTime.now(),
      }, 
      {
        'title': 'Data Structures & Algorithms',
        'description': 'Master DSA concepts and ace coding interviews',
        'category': 'Computer Science',
        'difficulty': 'Advanced',
        'duration': '10 weeks',
        'enrolledCount': 890,
        'iconCode': Icons.account_tree.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      {
        'title': 'Flutter Masterclass',
        'description': 'Build beautiful native apps with Flutter and Dart',
        'category': 'Mobile Dev',
        'difficulty': 'Intermediate',
        'duration': '10 weeks',
        'enrolledCount': 1500,
        'iconCode': Icons.phone_android.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      {
         'title': 'Machine Learning Basics',
        'description': 'Introduction to ML concepts and algorithms',
        'category': 'AI & ML',
        'difficulty': 'Advanced',
        'duration': '14 weeks',
        'enrolledCount': 600,
        'iconCode': Icons.psychology.codePoint.toString(),
        'createdAt': DateTime.now(),
      }
    ];

    for (var data in initialCourses) {
      await _coursesCollection.add(data);
    }
  }

  // Get User Certificates
  Stream<List<CertificateModel>> getUserCertificates(String userId) {
    return _certificatesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('issuedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CertificateModel.fromSnapshot(doc)).toList();
    });
  }

  // Issue Certificate (Example)
  Future<void> issueCertificate({
    required String userId,
    required String userName,
    required String courseId,
    required String courseTitle,
  }) async {
    // In a real app, this would likely happen via a Cloud Function for security
    // or after verifying course completion.
    await _certificatesCollection.add({
      'userId': userId,
      'userName': userName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'certificateUrl': 'https://placeholder.com/certificate.png', // Placeholder
      'issuedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get Leaderboard
  Stream<List<UserModel>> getLeaderboard() {
    return _usersCollection
        .orderBy('points', descending: true)
        .limit(50) // Limit to top 50 for performance
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
