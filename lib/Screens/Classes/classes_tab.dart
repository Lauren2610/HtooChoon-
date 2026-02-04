import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';

class ClassesTab extends StatelessWidget {
  ClassesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'My Classes',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 22),
          ),
          const SizedBox(width: AppTheme.spaceXs),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        children: [
          // Active Classes Section
          _SectionLabel(label: 'Active'),
          const SizedBox(height: AppTheme.spaceMd),
          _ClassListItem(
            title: 'Python Basics (Batch A)',
            days: 'Mon, Wed • 10:00 AM',
            instructor: 'Dr. Smith',
            progress: 0.45,
            statusColor: AppTheme.success,
            statusText: 'On Track',
          ),
          const SizedBox(height: AppTheme.spaceMd),
          _ClassListItem(
            title: 'Web Development Bootcamp',
            days: 'Tue, Thu • 2:00 PM',
            instructor: 'Prof. Johnson',
            progress: 0.1,
            statusColor: AppTheme.warning,
            statusText: 'Behind',
          ),

          const SizedBox(height: AppTheme.space2xl),

          // Past Classes Section
          _SectionLabel(label: 'Past'),
          const SizedBox(height: AppTheme.spaceMd),
          _ClassListItem(
            title: 'Intro to CS',
            days: 'Completed',
            instructor: 'Dr. Smith',
            progress: 1.0,
            statusColor: AppTheme.getTextTertiary(context),
            statusText: 'Completed',
            isCompleted: true,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppTheme.getTextTertiary(context),
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ClassListItem extends StatelessWidget {
  final String title;
  final String days;
  final String instructor;
  final double progress;
  final Color statusColor;
  final String statusText;
  final bool isCompleted;

  const _ClassListItem({
    required this.title,
    required this.days,
    required this.instructor,
    required this.progress,
    required this.statusColor,
    required this.statusText,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: AppTheme.borderRadiusLg,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.getSurfaceVariant(context)
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_outline
                        : Icons.class_outlined,
                    color: isCompleted
                        ? AppTheme.getTextSecondary(context)
                        : Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppTheme.getTextSecondary(context)
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space2xs),
                      Text(
                        instructor,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppTheme.getTextTertiary(context),
                          ),
                          const SizedBox(width: AppTheme.space2xs),
                          Text(
                            days,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.getTextSecondary(context),
                                  fontSize: 12,
                                ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceXs,
                              vertical: AppTheme.space2xs,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: AppTheme.borderRadiusSm,
                            ),
                            child: Text(
                              statusText,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (!isCompleted) ...[
                        const SizedBox(height: AppTheme.spaceSm),
                        ClipRRect(
                          borderRadius: AppTheme.borderRadiusSm,
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppTheme.getSurfaceVariant(
                              context,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress < 0.3
                                  ? AppTheme.warning
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ],
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
