import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../utils/helpers.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top 3 Podium
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
            child: _buildPodium(),
          ),

          // User's Rank Card
          if (currentUser != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor, width: 2),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      Helpers.getInitials(currentUser.displayName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Rank',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          currentUser.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '#${currentUser.rank}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        '${currentUser.points} pts',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Leaderboard List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(),
                _buildLeaderboardList(),
                _buildLeaderboardList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        _buildPodiumItem(2, 'Sarah Chen', 850, Colors.grey[400]!),
        const SizedBox(width: 16),
        // 1st Place
        _buildPodiumItem(1, 'Alex Kumar', 1200, AppTheme.warningColor),
        const SizedBox(width: 16),
        // 3rd Place
        _buildPodiumItem(3, 'Mike Johnson', 720, Colors.brown[300]!),
      ],
    );
  }

  Widget _buildPodiumItem(int rank, String name, int points, Color color) {
    final heights = {1: 120.0, 2: 90.0, 3: 70.0};
    final sizes = {1: 50.0, 2: 40.0, 3: 35.0};

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            CircleAvatar(
              radius: sizes[rank]!,
              backgroundColor: color,
              child: Text(
                Helpers.getInitials(name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            if (rank == 1)
              Positioned(
                top: -5,
                child: Icon(
                  Icons.emoji_events,
                  color: AppTheme.warningColor,
                  size: 24,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name.split(' ')[0],
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '$points pts',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: heights[rank],
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    final users = _getPlaceholderUsers();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final rank = index + 4; // Starting from 4th place

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(Helpers.getColorFromString(user['name'] ?? '')),
                child: Text(
                  Helpers.getInitials(user['name'] ?? ''),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name and Institution
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      user['institution'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Points
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${user['points']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  Text(
                    'points',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, String>> _getPlaceholderUsers() {
    return [
      {'name': 'Emma Wilson', 'institution': 'MIT', 'points': '680'},
      {'name': 'David Lee', 'institution': 'Stanford', 'points': '650'},
      {'name': 'Sophia Martinez', 'institution': 'Harvard', 'points': '620'},
      {'name': 'James Brown', 'institution': 'Berkeley', 'points': '590'},
      {'name': 'Olivia Taylor', 'institution': 'Oxford', 'points': '560'},
      {'name': 'Liam Anderson', 'institution': 'Cambridge', 'points': '530'},
      {'name': 'Ava Thomas', 'institution': 'Yale', 'points': '500'},
    ];
  }
}
