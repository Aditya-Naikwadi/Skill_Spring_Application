import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CertificateProgramModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String provider;
  final String duration;
  final int enrolledCount;
  final String iconCode;
  final String? imageUrl;
  final DateTime createdAt;

  CertificateProgramModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.provider,
    required this.duration,
    this.enrolledCount = 0,
    required this.iconCode,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'provider': provider,
      'duration': duration,
      'enrolledCount': enrolledCount,
      'iconCode': iconCode,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CertificateProgramModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CertificateProgramModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'General',
      provider: data['provider'] ?? 'SkillSpring',
      duration: data['duration'] ?? 'Unknown',
      enrolledCount: data['enrolledCount'] ?? 0,
      iconCode: data['iconCode'] ?? '61407', // Default to badge icon
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  IconData get iconData {
    return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
  }
}
