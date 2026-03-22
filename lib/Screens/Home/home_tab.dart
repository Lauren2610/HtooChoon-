import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Constants/app_colors.dart';
import 'package:htoochoon_flutter/Constants/text_constants.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Widgets/user_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // =================== LOADING STATE ===================
    if (authProvider.isLoading && user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // =================== ERROR STATE ===================
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDark
                    ? AppColors.iconErrorDark
                    : AppColors.iconError, // using your AppColors
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to load profile',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayName = user.name.toString();

    // =================== MAIN DASHBOARD ===================
    return Scaffold(
      appBar: UserAppBar(
        title: "Dashboard",
        showSearchIcon: true,
        leadIcon: Icons.dashboard,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 800;

          if (isWeb) {
            // 💻 WEB LAYOUT (ROW 2:3)
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LeftUserDashboard(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: RightDashboard(),
                  ),
                ),
              ],
            );
          } else {
            // 📱 MOBILE LAYOUT (SCROLL)
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  LeftUserDashboard(),
                  SizedBox(height: 16),
                  UpcomingLiveSection(),
                  SizedBox(height: 16),
                  EnrolledCoursesSection(),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class RightDashboard extends StatelessWidget {
  const RightDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          UpcomingLiveSection(),
          SizedBox(height: 16),
          EnrolledCoursesSection(),
        ],
      ),
    );
  }
}

class UpcomingLiveSection extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, String>> liveList;

  const UpcomingLiveSection({
    super.key,
    this.isLoading = false,
    this.liveList = const [
      {"title": "Physics Live Class", "time": "Today • 6 PM"},
      {"title": "Math Revision", "time": "Tomorrow • 4 PM"},
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming & Live",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        if (isLoading)
          const _LiveSessionShimmer()
        else
          Column(
            children: [
              ...liveList.map(
                (item) => _LiveCard(title: item["title"]!, time: item["time"]!),
              ),
            ],
          ),
      ],
    );
  }
}

class _LiveSessionShimmer extends StatelessWidget {
  const _LiveSessionShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150, height: 16, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(width: 100, height: 12, color: Colors.white),
                  ],
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.buttonPrimary,
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                "Join Now",

                style: TextStyle(
                  fontSize: AppTypography.kXs,
                  color: AppTextColors.kInverse(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnrolledCoursesSection extends StatelessWidget {
  final bool isLoading;
  final List<Map<String, dynamic>> courses;

  const EnrolledCoursesSection({
    super.key,
    this.isLoading = false,
    this.courses = const [
      {
        "title": "Quantum Physics",
        "progress": 0.7,
        "image": "https://images.unsplash.com/photo-1635070041078-e363dbe005cb",
      },
      {
        "title": "Calculus",
        "progress": 0.4,
        "image": "https://images.unsplash.com/photo-1509228468518-180dd4864904",
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Enrolled Courses",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        if (isLoading)
          const _EnrolledCoursesShimmer()
        else
          Column(
            children: [
              ...courses.map(
                (course) => CourseCard(
                  title: course["title"] as String,
                  progress: course["progress"] as double,
                  imageUrl: course["image"] as String,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EnrolledCoursesShimmer extends StatelessWidget {
  const _EnrolledCoursesShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Container(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 120, height: 16, color: Colors.white),
                      const SizedBox(height: 10),
                      Container(
                        height: 6,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 6),
                      Container(width: 80, height: 12, color: Colors.white),
                      const SizedBox(height: 12),
                      Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
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

class CourseCard extends StatelessWidget {
  final String title;
  final double progress;
  final String imageUrl;

  const CourseCard({
    super.key,
    required this.title,
    required this.progress,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias, // 👈 important for image
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ IMAGE
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📘 TITLE
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // 📊 PROGRESS BAR
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(value: progress, minHeight: 6),
                ),

                const SizedBox(height: 6),

                // % TEXT
                Text(
                  "${(progress * 100).toInt()}% completed",
                  style: const TextStyle(fontSize: 12),
                ),

                const SizedBox(height: 12),

                // 👉 CONTINUE BUTTON
                GestureDetector(
                  onTap: () {
                    // TODO: navigate to lesson
                    print("Continue tapped");
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Continue Lesson",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityBox extends StatelessWidget {
  const ActivityBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Activity", style: TextStyle(fontSize: 16)),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat("04", "Courses in progress"),
              _buildStat("12", "Tasks completed"),
            ],
          ),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Learning Streak", style: TextStyle(fontSize: 16)),
                  Text(
                    "8 days",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(
                Icons.stacked_bar_chart,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        Text(label),
      ],
    );
  }
}

class AiMentorSuggestion extends StatelessWidget {
  const AiMentorSuggestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "AI Mentor Suggestion",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),

          SizedBox(height: 12),

          Text(
            "Based on your last quiz, focus on Quantum Entanglement before Thursday.",
            style: TextStyle(color: Colors.white),
          ),

          SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Start Review", style: TextStyle(color: Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LeftUserDashboard extends StatelessWidget {
  const LeftUserDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.name ?? 'User';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('WELCOME BACK, $userName', style: AppTypography.kBody),
        const SizedBox(height: 4),
        Text('READY TO LEARN?', style: AppTypography.kDisplayMedium),
        const SizedBox(height: 16),
        const AiMentorSuggestion(),
        const SizedBox(height: 16),
        const ActivityBox(),
      ],
    );
  }
}
