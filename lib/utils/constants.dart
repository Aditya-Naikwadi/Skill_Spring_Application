class AppConstants {
  // App Info
  static const String appName = 'SkillSpring';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Learn Coding, Build Future';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleInstructor = 'instructor';
  static const String roleAdmin = 'admin';

  // Course Categories
  static const List<String> courseCategories = [
    'Programming Fundamentals',
    'Data Structures & Algorithms',
    'Computer Organization & Architecture',
    'Operating Systems',
    'Database Management Systems',
    'Computer Networks',
    'Discrete Mathematics',
    'Software Engineering',
    'Theory of Computation',
    'Object-Oriented Programming',
  ];

  static const Map<String, String> categoryDescriptions = {
    'Programming Fundamentals': 'Logic & Syntax',
    'Data Structures & Algorithms': 'Problem Solving',
    'Computer Organization & Architecture': 'Hardware/Software Interface',
    'Operating Systems': 'System Management',
    'Database Management Systems': 'Data Storage',
    'Computer Networks': 'Connectivity & Protocols',
    'Discrete Mathematics': 'Computational Logic',
    'Software Engineering': 'Development Lifecycle',
    'Theory of Computation': 'Automata & Languages',
    'Object-Oriented Programming': 'Design Patterns',
  };

  // Difficulty Levels
  static const String difficultyBeginner = 'Beginner';
  static const String difficultyIntermediate = 'Intermediate';
  static const String difficultyAdvanced = 'Advanced';

  // Points System
  static const int pointsCourseCompletion = 100;
  static const int pointsProjectSubmission = 50;
  static const int pointsQuizPerfect = 30;
  static const int pointsDailyLogin = 5;

  // Leaderboard Filters
  static const String leaderboardWeekly = 'Weekly';
  static const String leaderboardMonthly = 'Monthly';
  static const String leaderboardAllTime = 'All Time';

  // Firebase Collections
  static const String collectionUsers = 'users';
  static const String collectionCourses = 'courses';
  static const String collectionProjects = 'projects';
  static const String collectionLeaderboard = 'leaderboard';
  static const String collectionProgress = 'progress';
  static const String collectionCertificates = 'certificates'; // User issued certificates
  static const String collectionCertificatePrograms = 'certificate_programs'; // Available programs

  // Storage Paths
  static const String storageProfilePictures = 'profile_pictures';
  static const String storageCertificates = 'certificates';
  static const String storageCourseThumbnails = 'course_thumbnails';
  static const String storageCourseVideos = 'course_videos';
  static const String storageStudyMaterials = 'study_materials';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 10;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
}
