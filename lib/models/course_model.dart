import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String duration;
  final int enrolledCount;
  final String iconCode; // Store IconData codePoint
  final String? imageUrl;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.duration,
    this.enrolledCount = 0,
    required this.iconCode,
    this.imageUrl,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'enrolledCount': enrolledCount,
      'iconCode': iconCode,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory CourseModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      difficulty: data['difficulty'] ?? 'Beginner',
      duration: data['duration'] ?? 'Unknown',
      enrolledCount: data['enrolledCount'] ?? 0,
      iconCode: data['iconCode'] ?? '57347', // Default to code icon
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  // Helper to get IconData from string code
  IconData get iconData {
    return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
  }
}
