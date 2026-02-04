import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:flutter/material.dart';

class CoursesTab extends StatelessWidget {
  CoursesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Browse Courses',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Python, Math, Science...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  filled: true,
                  fillColor: AppTheme.getSurfaceVariant(context),
                  border: OutlineInputBorder(
                    borderRadius: AppTheme.borderRadiusLg,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spaceMd,
                  ),
                ),
              ),
            ),

            // Categories
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceLg,
                ),
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryChip(label: 'All', isSelected: true),
                  _CategoryChip(label: 'Computer Science'),
                  _CategoryChip(label: 'Mathematics'),
                  _CategoryChip(label: 'Business'),
                  _CategoryChip(label: 'Design'),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Featured Course
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  _FeaturedCourseCard(),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Course List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
              child: Text(
                'New Arrivals',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceMd),

            ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spaceLg,
                vertical: 0,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppTheme.spaceMd),
              itemBuilder: (context, index) {
                return _CourseCard(
                  title: 'Data Science with Python',
                  author: 'Dr. Angela Yu',
                  rating: 4.8,
                  students: 1200,
                  price: '\$49.99',
                );
              },
            ),

            const SizedBox(height: AppTheme.space2xl),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppTheme.spaceXs),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {},
        backgroundColor: Colors.transparent,
        selectedColor: Theme.of(context).colorScheme.primary,
        labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: isSelected
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : AppTheme.getBorder(context),
          ),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceSm,
          vertical: AppTheme.spaceXs,
        ),
      ),
    );
  }
}

class _FeaturedCourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)],
        ),
        borderRadius: AppTheme.borderRadiusXl,
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceSm,
              vertical: AppTheme.space2xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Text(
              'POPULAR',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            'Mastering Flutter Integration',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXs),
          Text(
            'Learn to build scalable apps with clean architecture.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final String title;
  final String author;
  final double rating;
  final int students;
  final String price;

  const _CourseCard({
    required this.title,
    required this.author,
    required this.rating,
    required this.students,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.getSurfaceVariant(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusLg),
                bottomLeft: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: Icon(
              Icons.image,
              color: AppTheme.getTextTertiary(context),
              size: 32,
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.space2xs),
                  Text(
                    author,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: AppTheme.space2xs),
                      Text(
                        '$rating',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppTheme.space2xs),
                      Text(
                        '($students)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextTertiary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
