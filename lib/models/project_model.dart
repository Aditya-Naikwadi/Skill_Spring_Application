import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String estimatedTime;
  final int completionsCount;
  final String iconCode;
  final String? imageUrl;
  final List<String> technologies;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedTime,
    this.completionsCount = 0,
    required this.iconCode,
    this.imageUrl,
    this.technologies = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'completionsCount': completionsCount,
      'iconCode': iconCode,
      'imageUrl': imageUrl,
      'technologies': technologies,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ProjectModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      difficulty: data['difficulty'] ?? 'Beginner',
      estimatedTime: data['estimatedTime'] ?? 'Unknown',
      completionsCount: data['completionsCount'] ?? 0,
      iconCode: data['iconCode'] ?? '59530', // Default to build icon
      imageUrl: data['imageUrl'],
      technologies: List<String>.from(data['technologies'] ?? []),
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  IconData get iconData {
    return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
  }
}
