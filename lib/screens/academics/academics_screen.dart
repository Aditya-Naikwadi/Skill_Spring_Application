import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../utils/constants.dart';
import '../../widgets/academics/folder_card.dart';
import '../../widgets/common/entry_animation.dart';
import 'subject_details_screen.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Define the 3 main sections
  final List<String> _sections = ['Courses', 'Projects', 'Certificates'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117), // Dark Background
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // 1. Branding Header
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0D1117).withValues(alpha: 0.9), // High opacity for readability
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                centerTitle: false,
                title: const Text(
                  'Academics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // Adjusted for Collapsed state
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withValues(alpha: 0.15),
                        const Color(0xFF0D1117),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                _buildHeaderIcon(Icons.search, () {}),
                const SizedBox(width: 12),
                _buildHeaderIcon(Icons.filter_list, () {}),
                const SizedBox(width: 24),
              ],
            ),

            // 2. Persistent Tab Bar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey[500],
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  tabs: _sections.map((section) => Tab(text: section)).toList(),
                  dividerColor: Colors.white10,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _sections.map((section) {
            return SubjectTab(type: section);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class SubjectTab extends StatefulWidget {
  final String type;

  const SubjectTab({super.key, required this.type});

  @override
  State<SubjectTab> createState() => _SubjectTabState();
}

class _SubjectTabState extends State<SubjectTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Map categories to icons and colors for visual distinction
    final List<Map<String, dynamic>> categories = AppConstants.courseCategories.map((category) {
      IconData icon;
      Color color;

      // Assign distinct icons and colors based on category name
      if (category.contains('Programming')) {
        icon = widget.type == 'Courses' ? Icons.terminal : (widget.type == 'Projects' ? Icons.laptop_mac : Icons.badge);
        color = Colors.blue;
      } else if (category.contains('Data Structures')) {
        icon = widget.type == 'Courses' ? Icons.account_tree : (widget.type == 'Projects' ? Icons.schema : Icons.workspace_premium);
        color = Colors.orange;
      } else if (category.contains('Architecture')) {
        icon = widget.type == 'Courses' ? Icons.memory : (widget.type == 'Projects' ? Icons.developer_board : Icons.verified);
        color = Colors.purple;
      } else if (category.contains('Operating Systems')) {
        icon = widget.type == 'Courses' ? Icons.settings_system_daydream : (widget.type == 'Projects' ? Icons.terminal_sharp : Icons.stars);
        color = Colors.teal;
      } else if (category.contains('Database')) {
        icon = widget.type == 'Courses' ? Icons.storage : (widget.type == 'Projects' ? Icons.dataset : Icons.military_tech);
        color = Colors.green;
      } else if (category.contains('Networks')) {
        icon = widget.type == 'Courses' ? Icons.router : (widget.type == 'Projects' ? Icons.lan : Icons.public);
        color = Colors.cyan;
      } else if (category.contains('Discrete')) {
        icon = widget.type == 'Courses' ? Icons.calculate : (widget.type == 'Projects' ? Icons.functions : Icons.fact_check);
        color = Colors.indigo;
      } else if (category.contains('Software')) {
        icon = widget.type == 'Courses' ? Icons.engineering : (widget.type == 'Projects' ? Icons.architecture_rounded : Icons.assignment_turned_in);
        color = Colors.red;
      } else if (category.contains('Computation')) {
        icon = widget.type == 'Courses' ? Icons.functions : (widget.type == 'Projects' ? Icons.auto_graph : Icons.history_edu);
        color = Colors.deepPurple;
      } else if (category.contains('Object-Oriented')) {
        icon = widget.type == 'Courses' ? Icons.data_object : (widget.type == 'Projects' ? Icons.category : Icons.card_membership);
        color = Colors.pink;
      } else {
        icon = Icons.folder;
        color = Colors.blueGrey;
      }

      return {
        'name': category,
        'description': AppConstants.categoryDescriptions[category] ?? 'Explore $category',
        'icon': icon,
        'color': color,
      };
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust grid based on screen width
        int crossAxisCount = 2;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        }

        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: CustomScrollView(
            controller: _scrollController,
            key: PageStorageKey<String>(widget.type),
            primary: false,
            slivers: [
              // Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getSectionIcon(widget.type),
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSectionDescription(widget.type),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.65,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = categories[index];
                      return EntryAnimatedWidget(
                        delay: Duration(milliseconds: 50 + (index * 50).clamp(0, 500)),
                        child: FolderCard(
                          title: category['name'],
                          subtitle: category['description'],
                          icon: category['icon'],
                          color: category['color'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubjectDetailsScreen(
                                  category: category['name'],
                                  type: widget.type,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    childCount: categories.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 60)),
            ],
          ),
        );
      },
    );
  }

  IconData _getSectionIcon(String type) {
    switch (type) {
      case 'Courses':
        return Icons.school_rounded;
      case 'Projects':
        return Icons.assignment_rounded;
      case 'Certificates':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.folder;
    }
  }

  String _getSectionDescription(String type) {
    switch (type) {
      case 'Courses':
        return 'Structured learning paths for core computer science subjects.';
      case 'Projects':
        return 'Hands-on practical applications to test your technical skills.';
      case 'Certificates':
        return 'Recognized credentials to validate your academic achievements.';
      default:
        return 'Explore various academic resources.';
    }
  }
}

// Delegate for Sticky Tab Bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar; // Renamed to simple tabBar

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0D1117), // Match background
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
