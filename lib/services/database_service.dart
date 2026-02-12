import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/certificate_model.dart';
import '../models/project_model.dart';
import '../models/certificate_program_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart'; // Import constants


class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get _coursesCollection => _firestore.collection(AppConstants.collectionCourses);
  CollectionReference get _projectsCollection => _firestore.collection(AppConstants.collectionProjects);
  CollectionReference get _certificateProgramsCollection => _firestore.collection(AppConstants.collectionCertificatePrograms);
  CollectionReference get _certificatesCollection => _firestore.collection(AppConstants.collectionCertificates);
  CollectionReference get _usersCollection => _firestore.collection(AppConstants.collectionUsers);

  // --- Courses ---
  Stream<List<CourseModel>> getCourses(String category, {int? limit}) {
    Query query = _coursesCollection.orderBy('createdAt', descending: true);
    if (category != 'All' && category != 'Recommended') { // Added Recommended check if needed
       query = query.where('category', isEqualTo: category);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snapshot) {
      return List.unmodifiable(snapshot.docs.map((doc) => CourseModel.fromSnapshot(doc)));
    });
  }

  // --- Projects ---
  Stream<List<ProjectModel>> getProjects(String category) {
    Query query = _projectsCollection.orderBy('createdAt', descending: true);
    if (category != 'All') {
       query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return List.unmodifiable(snapshot.docs.map((doc) => ProjectModel.fromSnapshot(doc)));
    });
  }

  // --- Certificate Programs ---
  Stream<List<CertificateProgramModel>> getCertificatePrograms(String category) {
    Query query = _certificateProgramsCollection.orderBy('createdAt', descending: true);
    if (category != 'All') {
       query = query.where('category', isEqualTo: category);
    }
    return query.snapshots().map((snapshot) {
      return List.unmodifiable(snapshot.docs.map((doc) => CertificateProgramModel.fromSnapshot(doc)));
    });
  }

// ... (seeding methods)

  // --- User Certificates (Issued) ---
  Stream<List<CertificateModel>> getUserCertificates(String userId) {
    return _certificatesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('issuedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return List.unmodifiable(snapshot.docs.map((doc) => CertificateModel.fromSnapshot(doc)));
    });
  }

// ...

  // --- Leaderboard ---
  Stream<List<UserModel>> getLeaderboard() {
    return _usersCollection
        .orderBy('points', descending: true)
        .limit(50) // Limit to top 50 for performance
        .snapshots()
        .map((snapshot) {
      return List.unmodifiable(snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure data is treated as a Map, handling potential nullability check from analyzer
        return UserModel.fromMap(data as Map<String, dynamic>);
      }));
    });
  }
}
