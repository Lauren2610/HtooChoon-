import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/app_colors.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/Widgets/user_appbar.dart';
// courses_tab.dart
// Refactored to match ClassesTab patterns:
//  - AppTheme helpers for dark/light theming (no hardcoded colors)
//  - colorScheme.primary replaces all hardcoded #007A8B greens
//  - InkWell hover/ripple on interactive cards
//  - Consistent border, radius, spacing tokens
//  - SegmentedButton and ChoiceChip use theme colors

class CoursesTab extends StatefulWidget {
  const CoursesTab({super.key});

  @override
  State<CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<CoursesTab> {
  String _selectedSegment = 'Skill Courses';
  int _selectedTopicIndex = 0;

  static const List<String> _topics = [
    'All Topics',
    'Data Science',
    'Design Thinking',
    'Marketing',
    'Development',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: UserAppBar(
        title: 'Dashboard',
        showSearchIcon: true,
        leadIcon: Icons.dashboard,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceLg,
            vertical: AppTheme.spaceMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Search Bar ──────────────────────────────────────────
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search courses, mentors, or skills...',
                  hintStyle: TextStyle(
                    color: AppTheme.getTextTertiary(context),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.getTextTertiary(context),
                  ),
                  filled: true,
                  fillColor: AppTheme.getSurfaceVariant(context),
                  border: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusMd,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusMd,
                    borderSide: BorderSide(
                      color: AppTheme.getBorder(context),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusMd,
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spaceMd,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // ── 2. Segmented Button ────────────────────────────────────
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Programs', label: Text('Programs')),
                  ButtonSegment(
                    value: 'Skill Courses',
                    label: Text('Skill Courses'),
                  ),
                ],
                selected: {_selectedSegment},
                onSelectionChanged: (Set<String> next) =>
                    setState(() => _selectedSegment = next.first),
                style: SegmentedButton.styleFrom(
                  backgroundColor: AppTheme.getSurfaceVariant(context),
                  selectedBackgroundColor: colorScheme.primary,
                  selectedForegroundColor: colorScheme.onPrimary,
                  foregroundColor: AppTheme.getTextSecondary(context),
                  side: BorderSide(color: AppTheme.getBorder(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // ── 3. Topic Chips ─────────────────────────────────────────
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedTopicIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spaceSm),
                      child: ChoiceChip(
                        label: Text(_topics[index]),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedTopicIndex = index),
                        selectedColor: colorScheme.primary,
                        backgroundColor: AppTheme.getSurfaceVariant(context),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : AppTheme.getTextSecondary(context),
                        ),
                        showCheckmark: false,
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : AppTheme.getBorder(context),
                        ),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spaceSm,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppTheme.space2xl),

              // ── 4. Featured Courses Header ─────────────────────────────
              _SectionHeader(
                eyebrow: 'SELECTED FOR YOU',
                title: 'Featured Skill Courses',
                actionLabel: 'View All',
                onAction: () {},
              ),
              const SizedBox(height: AppTheme.spaceMd),

              // ── 5. Featured Courses Horizontal List ────────────────────
              SizedBox(
                height: 260,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) => CourseCard(index: index),
                ),
              ),
              const SizedBox(height: AppTheme.space2xl),

              // ── 6. Top Organizations Header ────────────────────────────
              _SectionHeader(
                title: 'Top Organizations',
                actionLabel: 'Explore All',
                onAction: () {},
              ),
              const SizedBox(height: AppTheme.spaceMd),

              // ── 7. Organizations List ──────────────────────────────────
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => OrgTile(index: index),
              ),

              const SizedBox(height: AppTheme.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Section Header ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String? eyebrow;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    this.eyebrow,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Text(
                  eyebrow!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
              ],
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

// ── Course Card ──────────────────────────────────────────────────────────────

class CourseCard extends StatelessWidget {
  final int index;
  const CourseCard({super.key, this.index = 0});

  // Mock data for visual variety
  static const _titles = [
    'Mastering Figma UI/UX',
    'Python for Data Science',
    'Brand Strategy 101',
    'React Native Bootcamp',
  ];
  static const _orgs = ['CREATIVE HUB', 'DATA LAB', 'BRAND CO', 'DEV FORGE'];
  static const _prices = ['\$49.00', '\$69.00', '\$39.00', '\$89.00'];
  static const _ratings = ['4.9', '4.7', '4.8', '4.6'];
  static const _icons = [
    Icons.design_services,
    Icons.analytics,
    Icons.campaign,
    Icons.phone_android,
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final i = index % _titles.length;

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppTheme.borderRadiusLg,
          splashColor: colorScheme.primary.withOpacity(0.08),
          highlightColor: colorScheme.primary.withOpacity(0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Stack(
                children: [
                  Container(
                    height: 120,
                    color: colorScheme.primary.withOpacity(0.08),
                    child: Center(
                      child: Icon(
                        _icons[i],
                        size: 44,
                        color: colorScheme.primary.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: AppTheme.borderRadiusSm,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 13,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _ratings[i],
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Info
              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orgs[i],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      _titles[i],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppTheme.spaceSm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _prices[i],
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: AppTheme.borderRadiusSm,
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Org Tile ─────────────────────────────────────────────────────────────────

class OrgTile extends StatelessWidget {
  final int index;
  const OrgTile({super.key, this.index = 0});

  static const _names = ['Global University', 'Tech Academy', 'Design School'];
  static const _meta = [
    '124 Courses • 12k Students',
    '89 Courses • 8.4k Students',
    '57 Courses • 5.1k Students',
  ];
  static const _initials = ['GU', 'TA', 'DS'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final i = index % _names.length;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppTheme.borderRadiusLg,
          splashColor: colorScheme.primary.withOpacity(0.08),
          highlightColor: colorScheme.primary.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              children: [
                // Logo avatar
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.08),
                    borderRadius: AppTheme.borderRadiusMd,
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _initials[i],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _names[i],
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2xs),
                      Text(
                        _meta[i],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: AppTheme.getTextTertiary(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
