import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/app_colors.dart';
import 'package:htoochoon_flutter/Constants/text_constants.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Widgets/user_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';
// home_tab.dart
// Refactored to match ClassesTab / CoursesTab patterns:
//  - AppTheme helpers everywhere (no hardcoded colors)
//  - colorScheme.primary replaces AppColors.buttonPrimary / primaryColor
//  - InkWell hover/ripple on all interactive cards
//  - Consistent AppTheme border, radius, spacing tokens
//  - Shimmer uses theme-aware colors for dark/light mode
//  - GestureDetector → Material + InkWell on CourseCard CTA

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // ── Loading ─────────────────────────────────────────────────────────────
    if (authProvider.isLoading && user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    // ── Error ────────────────────────────────────────────────────────────────
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppTheme.getTextTertiary(context),
              ),
              const SizedBox(height: AppTheme.spaceMd),
              Text(
                'Unable to load profile',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.getTextSecondary(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Main ─────────────────────────────────────────────────────────────────
    return Scaffold(
      appBar: UserAppBar(
        title: 'Dashboard',
        showSearchIcon: true,
        leadIcon: Icons.dashboard,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 800;

          if (isWeb) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    child: LeftUserDashboard(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    child: const _RightDashboard(),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              children: const [
                LeftUserDashboard(),
                SizedBox(height: AppTheme.spaceLg),
                UpcomingLiveSection(),
                SizedBox(height: AppTheme.spaceLg),
                EnrolledCoursesSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Right Dashboard (web) ────────────────────────────────────────────────────

class _RightDashboard extends StatelessWidget {
  const _RightDashboard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        UpcomingLiveSection(),
        SizedBox(height: AppTheme.spaceLg),
        EnrolledCoursesSection(),
      ],
    );
  }
}

// ── Left Dashboard ───────────────────────────────────────────────────────────

class LeftUserDashboard extends StatelessWidget {
  const LeftUserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.name ?? 'User';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME BACK, $userName',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.getTextTertiary(context),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.space2xs),
        Text(
          'Ready to Learn?',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spaceLg),
        const AiMentorSuggestion(),
        const SizedBox(height: AppTheme.spaceMd),
        const ActivityBox(),
      ],
    );
  }
}

// ── AI Mentor Suggestion ─────────────────────────────────────────────────────

class AiMentorSuggestion extends StatelessWidget {
  const AiMentorSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: AppTheme.borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: colorScheme.onPrimary,
                size: 18,
              ),
              const SizedBox(width: AppTheme.spaceXs),
              Text(
                'AI Mentor Suggestion',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            'Based on your last quiz, focus on Quantum Entanglement before Thursday.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          // CTA with InkWell hover
          ClipRRect(
            borderRadius: AppTheme.borderRadiusMd,
            child: Material(
              color: colorScheme.onPrimary.withOpacity(0.15),
              child: InkWell(
                onTap: () {},
                splashColor: colorScheme.onPrimary.withOpacity(0.15),
                highlightColor: colorScheme.onPrimary.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMd,
                    vertical: AppTheme.spaceXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Review',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: AppTheme.spaceXs),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: colorScheme.onPrimary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity Box ─────────────────────────────────────────────────────────────

class ActivityBox extends StatelessWidget {
  const ActivityBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Activity',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              Expanded(
                child: _StatChip(number: '04', label: 'Courses in progress'),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: _StatChip(number: '12', label: 'Tasks completed'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            decoration: BoxDecoration(
              color: AppTheme.getSurfaceVariant(context),
              borderRadius: AppTheme.borderRadiusMd,
              border: Border.all(color: AppTheme.getBorder(context)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Streak',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      '8 days 🔥',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.stacked_bar_chart_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String number;
  final String label;

  const _StatChip({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceSm),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariant(context),
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: AppTheme.space2xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upcoming Live Section ────────────────────────────────────────────────────

class UpcomingLiveSection extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, String>> liveList;

  const UpcomingLiveSection({
    super.key,
    this.isLoading = false,
    this.liveList = const [
      {'title': 'Physics Live Class', 'time': 'Today • 6 PM'},
      {'title': 'Math Revision', 'time': 'Tomorrow • 4 PM'},
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming & Live',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        if (isLoading)
          const _LiveSessionShimmer()
        else
          ...liveList.map(
            (item) => _LiveCard(title: item['title']!, time: item['time']!),
          ),
      ],
    );
  }
}

class _LiveSessionShimmer extends StatelessWidget {
  const _LiveSessionShimmer();

  @override
  Widget build(BuildContext context) {
    // Theme-aware shimmer colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spaceSm),
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppTheme.borderRadiusLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 14, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(width: 100, height: 12, color: Colors.white),
                  ],
                ),
                Container(
                  width: 72,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTheme.borderRadiusMd,
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

class _LiveCard extends StatelessWidget {
  final String title;
  final String time;

  const _LiveCard({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          splashColor: colorScheme.primary.withOpacity(0.08),
          highlightColor: colorScheme.primary.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Live indicator dot + info
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceSm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: AppTheme.space2xs),
                        Text(
                          time,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.getTextSecondary(context),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Join Now button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceSm,
                    vertical: AppTheme.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                  child: Text(
                    'Join Now',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
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

// ── Enrolled Courses Section ─────────────────────────────────────────────────

class EnrolledCoursesSection extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> courses;

  const EnrolledCoursesSection({
    super.key,
    this.isLoading = false,
    this.courses = const [
      {
        'title': 'Quantum Physics',
        'progress': 0.7,
        'image': 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb',
      },
      {
        'title': 'Calculus',
        'progress': 0.4,
        'image': 'https://images.unsplash.com/photo-1509228468518-180dd4864904',
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enrolled Courses',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppTheme.spaceMd),
        if (isLoading)
          const _EnrolledCoursesShimmer()
        else
          ...courses.map(
            (course) => _EnrolledCourseCard(
              title: course['title'] as String,
              progress: course['progress'] as double,
              imageUrl: course['image'] as String,
            ),
          ),
      ],
    );
  }
}

class _EnrolledCoursesShimmer extends StatelessWidget {
  const _EnrolledCoursesShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlight = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        children: List.generate(
          2,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: AppTheme.borderRadiusLg,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 14, color: Colors.white),
                      const SizedBox(height: AppTheme.spaceSm),
                      Container(
                        height: 6,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Container(width: 80, height: 12, color: Colors.white),
                      const SizedBox(height: AppTheme.spaceMd),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppTheme.borderRadiusMd,
                        ),
                      ),
                    ],
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

class _EnrolledCourseCard extends StatelessWidget {
  final String title;
  final double progress;
  final String imageUrl;

  const _EnrolledCourseCard({
    required this.title,
    required this.progress,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceMd),
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
          splashColor: colorScheme.primary.withOpacity(0.08),
          highlightColor: colorScheme.primary.withOpacity(0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),

              Padding(
                padding: const EdgeInsets.all(AppTheme.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceSm),

                    // Progress bar
                    ClipRRect(
                      borderRadius: AppTheme.borderRadiusSm,
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppTheme.getSurfaceVariant(context),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress < 0.3
                              ? AppTheme.warning
                              : colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceXs),

                    // % label
                    Text(
                      '${(progress * 100).toInt()}% completed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),

                    // Continue button — full InkWell CTA
                    ClipRRect(
                      borderRadius: AppTheme.borderRadiusMd,
                      child: Material(
                        color: colorScheme.primary,
                        child: InkWell(
                          onTap: () {},
                          splashColor: Colors.white.withOpacity(0.15),
                          highlightColor: Colors.white.withOpacity(0.08),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppTheme.spaceSm,
                              horizontal: AppTheme.spaceMd,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue Lesson',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(width: AppTheme.spaceXs),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
