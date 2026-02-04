import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';

import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/invitations_tab.dart';
import 'package:htoochoon_flutter/Providers/notificaton_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:htoochoon_flutter/Theme/themedata.dart';

class NotiAndEmails extends StatefulWidget {
  NotiAndEmails({super.key});

  @override
  State<NotiAndEmails> createState() => _NotiAndEmailsState();
}

class _NotiAndEmailsState extends State<NotiAndEmails>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      context.read<NotificationProvider>().init(
        vsync: this,
        email: user.email!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Notifications',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: provider.tabController,
          labelStyle: Theme.of(context).textTheme.labelLarge,
          tabs: const [
            Tab(text: 'Invitations'),
            Tab(text: 'Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: provider.tabController,
        children: const [InvitationsTab(), AnnouncementsTab()],
      ),
    );
  }
}

/// Invitations Tab - Show pending organization/class invitations
class InvitationsTab extends StatelessWidget {
  const InvitationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to actual invitation data from NotificationProvider
    // This is a placeholder implementation

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      children: [
        _InvitationCard(
          organizationName: 'Tech Academy',
          role: 'Teacher',
          invitedBy: 'John Smith',
          date: '2 hours ago',
          onAccept: () {
            // TODO: Implement accept invitation
          },
          onDecline: () {
            // TODO: Implement decline invitation
          },
        ),
        const SizedBox(height: AppTheme.spaceMd),
        _InvitationCard(
          organizationName: 'Data Science Institute',
          role: 'Student',
          invitedBy: 'Dr. Johnson',
          date: 'Yesterday',
          onAccept: () {},
          onDecline: () {},
        ),
      ],
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final String organizationName;
  final String role;
  final String invitedBy;
  final String date;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _InvitationCard({
    required this.organizationName,
    required this.role,
    required this.invitedBy,
    required this.date,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceXs),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusMd,
                ),
                child: Icon(
                  Icons.mail_outline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organizationName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      'Invited as $role',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextTertiary(context),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            'Invited by $invitedBy',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.error,
                    side: BorderSide(color: AppTheme.error, width: 1),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Announcements Tab - Show system and organization announcements
class AnnouncementsTab extends StatelessWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Connect to actual announcement data from NotificationProvider
    // This is a placeholder implementation

    return ListView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      children: [
        _AnnouncementCard(
          title: 'System Maintenance',
          message:
              'The platform will be down for maintenance on Sunday from 2-4 AM.',
          type: AnnouncementType.system,
          date: '3 hours ago',
        ),
        const SizedBox(height: AppTheme.spaceMd),
        _AnnouncementCard(
          title: 'New Course Available',
          message:
              'Advanced Python Programming is now available for enrollment.',
          type: AnnouncementType.info,
          date: 'Yesterday',
        ),
        const SizedBox(height: AppTheme.spaceMd),
        _AnnouncementCard(
          title: 'Exam Schedule',
          message:
              'Final exams will be held next week. Please check your schedule.',
          type: AnnouncementType.important,
          date: '2 days ago',
        ),
      ],
    );
  }
}

enum AnnouncementType { system, info, important }

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String message;
  final AnnouncementType type;
  final String date;

  const _AnnouncementCard({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
  });

  Color _getTypeColor(BuildContext context) {
    switch (type) {
      case AnnouncementType.system:
        return AppTheme.info;
      case AnnouncementType.info:
        return AppTheme.success;
      case AnnouncementType.important:
        return AppTheme.warning;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case AnnouncementType.system:
        return Icons.settings;
      case AnnouncementType.info:
        return Icons.info_outline;
      case AnnouncementType.important:
        return Icons.priority_high;
    }
  }

  String _getTypeLabel() {
    switch (type) {
      case AnnouncementType.system:
        return 'SYSTEM';
      case AnnouncementType.info:
        return 'INFO';
      case AnnouncementType.important:
        return 'IMPORTANT';
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceXs),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusMd,
                ),
                child: Icon(_getTypeIcon(), color: typeColor, size: 20),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceXs,
                  vertical: AppTheme.space2xs,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: AppTheme.borderRadiusSm,
                ),
                child: Text(
                  _getTypeLabel(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextTertiary(context),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSm),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.space2xs),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
