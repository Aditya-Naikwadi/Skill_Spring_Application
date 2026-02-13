import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../models/project_model.dart';
import '../models/certificate_model.dart';
import '../services/database_service.dart';

enum DashboardStatus { loading, success, error }

class DashboardProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<CourseModel> _courses = [];
  List<ProjectModel> _projects = [];
  List<CertificateModel> _certificates = [];
  DashboardStatus _status = DashboardStatus.loading;
  String? _errorMessage;

  List<CourseModel> get courses => _courses;
  List<ProjectModel> get projects => _projects;
  List<CertificateModel> get certificates => _certificates;
  DashboardStatus get status => _status;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _coursesSub;
  StreamSubscription? _projectsSub;
  StreamSubscription? _certificatesSub;

  void initialize(String userId) {
    _status = DashboardStatus.loading;
    notifyListeners();

    _cancelSubscriptions();

    // Initialize Streams
    _coursesSub = _dbService.getCourses('All').listen(
      (data) {
        _courses = data;
        _checkSuccess();
      },
      onError: (e) => _handleError(e),
    );

    _projectsSub = _dbService.getProjects('All').listen(
      (data) {
        _projects = data;
        _checkSuccess();
      },
      onError: (e) => _handleError(e),
    );

    _certificatesSub = _dbService.getUserCertificates(userId).listen(
      (data) {
        _certificates = data;
        _checkSuccess();
      },
      onError: (e) => _handleError(e),
    );
  }

  void _checkSuccess() {
    // If we have data (even empty lists) from all streams, we consider it success
    if (_status != DashboardStatus.success) {
      _status = DashboardStatus.success;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  void _handleError(dynamic e) {
    _status = DashboardStatus.error;
    _errorMessage = e.toString();
    notifyListeners();
  }

  void _cancelSubscriptions() {
    _coursesSub?.cancel();
    _projectsSub?.cancel();
    _certificatesSub?.cancel();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    super.dispose();
  }
}
