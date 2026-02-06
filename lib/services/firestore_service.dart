import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/certificate_model.dart';
import '../models/leaderboard_entry.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== COURSES ====================

  // Get all courses
  Stream<List<CourseModel>> getAllCourses() {
    return _firestore
        .collection(AppConstants.collectionCourses)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromMap(doc.data()))
            .toList());
  }

  // Get courses by category
  Stream<List<CourseModel>> getCoursesByCategory(String category) {
    if (category == 'All') {
      return getAllCourses();
    }

    return _firestore
        .collection(AppConstants.collectionCourses)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromMap(doc.data()))
            .toList());
  }

  // Get featured courses
  Stream<List<CourseModel>> getFeaturedCourses() {
    return _firestore
        .collection(AppConstants.collectionCourses)
        .where('isFeatured', isEqualTo: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourseModel.fromMap(doc.data()))
            .toList());
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.collectionCourses)
          .doc(courseId)
          .get();

      if (doc.exists) {
        return CourseModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to load course details.';
    }
  }

  // Enroll in course
  Future<void> enrollInCourse(String userId, String courseId) async {
    try {
      // Add course to user's enrolled courses
      await _firestore.collection('users').doc(userId).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId]),
      });

      // Increment course enrollment count
      await _firestore.collection(AppConstants.collectionCourses).doc(courseId).update({
        'enrolledCount': FieldValue.increment(1),
      });

      // Create progress document
      await _firestore
          .collection(AppConstants.collectionProgress)
          .doc(userId)
          .collection('courses')
          .doc(courseId)
          .set({
        'courseId': courseId,
        'completionPercentage': 0,
        'lastAccessed': FieldValue.serverTimestamp(),
        'moduleProgress': {},
        'startedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to enroll in course.';
    }
  }

  // Update course progress
  Future<void> updateCourseProgress(
    String userId,
    String courseId,
    double completionPercentage,
    Map<String, bool> moduleProgress,
  ) async {
    try {
      await _firestore
          .collection(AppConstants.collectionProgress)
          .doc(userId)
          .collection('courses')
          .doc(courseId)
          .update({
        'completionPercentage': completionPercentage,
        'moduleProgress': moduleProgress,
        'lastAccessed': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update progress.';
    }
  }

  // Get user's course progress
  Stream<Map<String, dynamic>?> getCourseProgress(
    String userId,
    String courseId,
  ) {
    return _firestore
        .collection(AppConstants.collectionProgress)
        .doc(userId)
        .collection('courses')
        .doc(courseId)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  // ==================== LEADERBOARD ====================

  // Get leaderboard (all time)
  Stream<List<LeaderboardEntry>> getLeaderboard({int limit = 100}) {
    return _firestore
        .collection(AppConstants.collectionLeaderboard)
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final entries = snapshot.docs
          .map((doc) => LeaderboardEntry.fromMap(doc.data()))
          .toList();

      // Update ranks
      for (int i = 0; i < entries.length; i++) {
        entries[i] = LeaderboardEntry(
          userId: entries[i].userId,
          userName: entries[i].userName,
          profilePictureUrl: entries[i].profilePictureUrl,
          institution: entries[i].institution,
          points: entries[i].points,
          rank: i + 1,
          coursesCompleted: entries[i].coursesCompleted,
          projectsCompleted: entries[i].projectsCompleted,
          badges: entries[i].badges,
          lastUpdated: entries[i].lastUpdated,
        );
      }

      return entries;
    });
  }

  // Update user points
  Future<void> updateUserPoints(String userId, int pointsToAdd) async {
    try {
      await _firestore.collection(AppConstants.collectionLeaderboard).doc(userId).update({
        'points': FieldValue.increment(pointsToAdd),
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Also update in user document
      await _firestore.collection('users').doc(userId).update({
        'points': FieldValue.increment(pointsToAdd),
      });
    } catch (e) {
      throw 'Failed to update points.';
    }
  }

  // ==================== CERTIFICATES ====================

  // Get user certificates
  Stream<List<CertificateModel>> getUserCertificates(String userId) {
    return _firestore
        .collection(AppConstants.collectionCertificates)
        .where('userId', isEqualTo: userId)
        .orderBy('issueDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CertificateModel.fromMap(doc.data()))
            .toList());
  }

  // Create certificate
  Future<void> createCertificate(CertificateModel certificate) async {
    try {
      await _firestore
          .collection(AppConstants.collectionCertificates)
          .doc(certificate.id)
          .set(certificate.toMap());
    } catch (e) {
      throw 'Failed to create certificate.';
    }
  }

  // Search courses
  Future<List<CourseModel>> searchCourses(String query) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.collectionCourses)
          .get();

      final courses = snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data()))
          .where((course) =>
              course.title.toLowerCase().contains(query.toLowerCase()) ||
              course.description.toLowerCase().contains(query.toLowerCase()) ||
              course.category.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return courses;
    } catch (e) {
      throw 'Failed to search courses.';
    }
  }
}
