import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
