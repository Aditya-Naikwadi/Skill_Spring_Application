import 'package:cloud_firestore/cloud_firestore.dart';

enum CourseDifficulty {
  beginner,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case CourseDifficulty.beginner:
        return 'Beginner';
      case CourseDifficulty.intermediate:
        return 'Intermediate';
      case CourseDifficulty.advanced:
        return 'Advanced';
    }
  }
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final int order;
  final int durationMinutes;
  final String? videoUrl;
  final String? studyMaterialUrl;
  final List<String> topics;

  CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.durationMinutes,
    this.videoUrl,
    this.studyMaterialUrl,
    this.topics = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'durationMinutes': durationMinutes,
      'videoUrl': videoUrl,
      'studyMaterialUrl': studyMaterialUrl,
      'topics': topics,
    };
  }

  factory CourseModule.fromMap(Map<String, dynamic> map) {
    return CourseModule(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      order: map['order'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 0,
      videoUrl: map['videoUrl'],
      studyMaterialUrl: map['studyMaterialUrl'],
      topics: List<String>.from(map['topics'] ?? []),
    );
  }
}

class ProjectGuide {
  final String id;
  final String title;
  final String description;
  final String difficulty;
  final int estimatedHours;
  final List<String> steps;
  final List<String> resources;

  ProjectGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.estimatedHours,
    this.steps = const [],
    this.resources = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'difficulty': difficulty,
      'estimatedHours': estimatedHours,
      'steps': steps,
      'resources': resources,
    };
  }

  factory ProjectGuide.fromMap(Map<String, dynamic> map) {
    return ProjectGuide(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      difficulty: map['difficulty'] ?? 'Beginner',
      estimatedHours: map['estimatedHours'] ?? 0,
      steps: List<String>.from(map['steps'] ?? []),
      resources: List<String>.from(map['resources'] ?? []),
    );
  }
}

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final CourseDifficulty difficulty;
  final String thumbnailUrl;
  final List<CourseModule> modules;
  final List<ProjectGuide> projects;
  final String? instructorId;
  final String instructorName;
  final int estimatedHours;
  final int enrolledCount;
  final double rating;
  final List<String> learningOutcomes;
  final List<String> prerequisites;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.thumbnailUrl,
    this.modules = const [],
    this.projects = const [],
    this.instructorId,
    required this.instructorName,
    required this.estimatedHours,
    this.enrolledCount = 0,
    this.rating = 0.0,
    this.learningOutcomes = const [],
    this.prerequisites = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty.name,
      'thumbnailUrl': thumbnailUrl,
      'modules': modules.map((m) => m.toMap()).toList(),
      'projects': projects.map((p) => p.toMap()).toList(),
      'instructorId': instructorId,
      'instructorName': instructorName,
      'estimatedHours': estimatedHours,
      'enrolledCount': enrolledCount,
      'rating': rating,
      'learningOutcomes': learningOutcomes,
      'prerequisites': prerequisites,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isFeatured': isFeatured,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      difficulty: CourseDifficulty.values.firstWhere(
        (e) => e.name == map['difficulty'],
        orElse: () => CourseDifficulty.beginner,
      ),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      modules: (map['modules'] as List<dynamic>?)
              ?.map((m) => CourseModule.fromMap(m as Map<String, dynamic>))
              .toList() ??
          [],
      projects: (map['projects'] as List<dynamic>?)
              ?.map((p) => ProjectGuide.fromMap(p as Map<String, dynamic>))
              .toList() ??
          [],
      instructorId: map['instructorId'],
      instructorName: map['instructorName'] ?? 'Unknown',
      estimatedHours: map['estimatedHours'] ?? 0,
      enrolledCount: map['enrolledCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      learningOutcomes: List<String>.from(map['learningOutcomes'] ?? []),
      prerequisites: List<String>.from(map['prerequisites'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  // Get total duration in minutes
  int get totalDuration {
    return modules.fold(0, (total, module) => total + module.durationMinutes);
  }

  // Get module count
  int get moduleCount => modules.length;

  // Get project count
  int get projectCount => projects.length;
}
