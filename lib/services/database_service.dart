import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/certificate_model.dart';
import '../models/project_model.dart';
import '../models/certificate_program_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart'; // Import constants
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _coursesCollection => _firestore.collection(AppConstants.collectionCourses);
  CollectionReference get _projectsCollection => _firestore.collection(AppConstants.collectionProjects);
  CollectionReference get _certificateProgramsCollection => _firestore.collection(AppConstants.collectionCertificatePrograms);
  CollectionReference get _certificatesCollection => _firestore.collection(AppConstants.collectionCertificates);
  CollectionReference get _usersCollection => _firestore.collection(AppConstants.collectionUsers);

  // --- Courses ---
  Stream<List<CourseModel>> getCourses(String category) {
    Query query = _coursesCollection.orderBy('createdAt', descending: true);
    if (category != 'All' && category != 'Recommended') { // Added Recommended check if needed
       query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CourseModel.fromSnapshot(doc)).toList();
    });
  }

  // --- Projects ---
  Stream<List<ProjectModel>> getProjects(String category) {
    Query query = _projectsCollection.orderBy('createdAt', descending: true);
    if (category != 'All') {
       query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromSnapshot(doc)).toList();
    });
  }

  // --- Certificate Programs ---
  Stream<List<CertificateProgramModel>> getCertificatePrograms(String category) {
    Query query = _certificateProgramsCollection.orderBy('createdAt', descending: true);
    if (category != 'All') {
       query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CertificateProgramModel.fromSnapshot(doc)).toList();
    });
  }

  // --- Seeding ---
  Future<void> seedAllData() async {
    await seedInitialCourses();
    await seedInitialProjects();
    await seedInitialCertificatePrograms();
  }

  Future<void> seedInitialCourses() async {
    final snapshot = await _coursesCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final List<Map<String, dynamic>> initialCourses = [
      // Programming Fundamentals
      {
        'title': 'Logic Building Masters',
        'description': 'Master the art of programming logic using pseudocode and flowcharts.',
        'category': 'Programming Fundamentals',
        'difficulty': 'Beginner',
        'duration': '4 weeks',
        'enrolledCount': 1500,
        'iconCode': Icons.code.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      // DSA
      {
        'title': 'DSA in Python',
        'description': 'Comprehensive guide to Data Structures and Algorithms.',
        'category': 'Data Structures & Algorithms',
        'difficulty': 'Intermediate',
        'duration': '12 weeks',
        'enrolledCount': 3200,
        'iconCode': Icons.account_tree.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      // OOP
      {
        'title': 'Java OOP Patterns',
        'description': 'Deep dive into Object-Oriented Design Patterns.',
        'category': 'Object-Oriented Programming',
        'difficulty': 'Advanced',
        'duration': '8 weeks',
        'enrolledCount': 900,
        'iconCode': Icons.data_object.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      // Web Dev (Software Engineering context)
      {
         'title': 'Agile Software Development',
         'description': 'Learn Scrum, Kanban and modern development lifecycles.',
         'category': 'Software Engineering',
         'difficulty': 'Beginner',
         'duration': '6 weeks',
         'enrolledCount': 1100,
         'iconCode': Icons.engineering.codePoint.toString(),
         'createdAt': DateTime.now(),
      }
    ];

    for (var data in initialCourses) {
      await _coursesCollection.add(data);
    }
  }

  Future<void> seedInitialProjects() async {
    final snapshot = await _projectsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final List<Map<String, dynamic>> initialProjects = [
      {
        'title': 'Inventory Management System',
        'description': 'Build a robust system using Python and SQL.',
        'category': 'Database Management Systems',
        'difficulty': 'Intermediate',
        'estimatedTime': '20 hours',
        'completionsCount': 45,
        'iconCode': Icons.storage.codePoint.toString(),
        'technologies': ['Python', 'SQL', 'Tkinter'],
        'createdAt': DateTime.now(),
      },
      {
        'title': 'Custom Operating System Kernel',
        'description': 'Write a simple 32-bit kernel from scratch.',
        'category': 'Operating Systems',
        'difficulty': 'Advanced',
        'estimatedTime': '50 hours',
        'completionsCount': 12,
        'iconCode': Icons.memory.codePoint.toString(),
        'technologies': ['C', 'Assembly'],
        'createdAt': DateTime.now(),
      },
       {
        'title': 'Chat Application',
        'description': 'Real-time chat app using Socket.io.',
        'category': 'Computer Networks',
        'difficulty': 'Intermediate',
        'estimatedTime': '15 hours',
        'completionsCount': 200,
        'iconCode': Icons.chat.codePoint.toString(),
        'technologies': ['Node.js', 'Socket.io'],
        'createdAt': DateTime.now(),
      },
    ];

    for (var data in initialProjects) {
      await _projectsCollection.add(data);
    }
  }

  Future<void> seedInitialCertificatePrograms() async {
    final snapshot = await _certificateProgramsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final List<Map<String, dynamic>> initialPrograms = [
      {
        'title': 'Certified Network Associate',
        'description': 'Validation of networking fundamentals.',
        'category': 'Computer Networks',
        'provider': 'SkillSpring',
        'duration': '6 months',
        'enrolledCount': 500,
        'iconCode': Icons.router.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
      {
        'title': 'Professional Data Architect',
        'description': 'Mastery in designing complex database systems.',
        'category': 'Database Management Systems',
        'provider': 'SkillSpring',
        'duration': '8 months',
        'enrolledCount': 300,
        'iconCode': Icons.dns.codePoint.toString(),
        'createdAt': DateTime.now(),
      },
    ];

    for (var data in initialPrograms) {
      await _certificateProgramsCollection.add(data);
    }
  }

  // --- User Certificates (Issued) ---
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
    await _certificatesCollection.add({
      'userId': userId,
      'userName': userName,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'certificateUrl': 'https://placeholder.com/certificate.png', // Placeholder
      'issuedAt': FieldValue.serverTimestamp(),
    });
  }

  // --- Leaderboard ---
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
