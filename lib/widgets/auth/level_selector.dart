import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ExperienceLevel { beginner, mid, pro }

class LevelSelector extends StatelessWidget {
  final ExperienceLevel selectedLevel;
  final Function(ExperienceLevel) onLevelSelected;

  const LevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Level',
          style: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildLevelCard(
              context,
              ExperienceLevel.beginner,
              'BEGINNER',
              Icons.school,
            ),
            const SizedBox(width: 12),
            _buildLevelCard(
              context,
              ExperienceLevel.mid,
              'MID',
              Icons.code,
            ),
            const SizedBox(width: 12),
            _buildLevelCard(
              context,
              ExperienceLevel.pro,
              'PRO',
              Icons.rocket_launch,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    ExperienceLevel level,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => onLevelSelected(level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 90,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1976D2).withValues(alpha: 0.1)
                : const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF2196F3) : Colors.white.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFF2196F3) : Colors.grey,
                  size: 20, // Slightly smaller icon
                ),
                const SizedBox(height: 4), // Reduced spacing
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: isSelected ? const Color(0xFF2196F3) : Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
