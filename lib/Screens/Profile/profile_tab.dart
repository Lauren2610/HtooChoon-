import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';
import 'package:htoochoon_flutter/Screens/AuthScreens/login_screen.dart';
import 'package:provider/provider.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Providers/user_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
// settings_screen.dart
// Full settings page with 5 tabs: General, Profile, Organizations, Security, Notifications
// Layout: Left settings-nav sidebar + right content area (web) or single scroll (mobile)
// Matches screenshot pixel-accurately for General tab.
// All other tabs follow the same visual language.

// ═══════════════════════════════════════════════════════════════════════════════
// ENTRY — SettingsScreen
// ═══════════════════════════════════════════════════════════════════════════════

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedTab = 0;

  static const List<_SettingsNavItem> _navItems = [
    _SettingsNavItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'General',
    ),
    _SettingsNavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
    _SettingsNavItem(
      icon: Icons.business_outlined,
      selectedIcon: Icons.business,
      label: 'Organizations',
    ),
    _SettingsNavItem(
      icon: Icons.shield_outlined,
      selectedIcon: Icons.shield,
      label: 'Security',
    ),
    _SettingsNavItem(
      icon: Icons.notifications_none,
      selectedIcon: Icons.notifications,
      label: 'Notifications',
    ),
  ];

  Widget get _currentTab => switch (_selectedTab) {
    0 => const _GeneralTab(),
    1 => const _ProfileTab(),
    2 => const _OrganizationsTab(),
    3 => const _SecurityTab(),
    4 => const _NotificationsTab(),
    _ => const _GeneralTab(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          return Column(
            children: [
              // ── Top AppBar ──────────────────────────────────────────────
              _SettingsAppBar(),

              Expanded(
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left settings nav
                          _SettingsNav(
                            items: _navItems,
                            selectedIndex: _selectedTab,
                            onTap: (i) => setState(() => _selectedTab = i),
                          ),
                          // Content
                          Expanded(child: _currentTab),
                        ],
                      )
                    : Column(
                        children: [
                          // Mobile: horizontal tab bar
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceMd,
                              vertical: AppTheme.spaceXs,
                            ),
                            child: Row(
                              children: List.generate(_navItems.length, (i) {
                                final item = _navItems[i];
                                final sel = _selectedTab == i;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedTab = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    margin: const EdgeInsets.only(
                                      right: AppTheme.spaceXs,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppTheme.spaceMd,
                                      vertical: AppTheme.spaceXs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sel
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : AppTheme.getSurfaceVariant(context),
                                      borderRadius: AppTheme.borderRadiusMd,
                                    ),
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: sel
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : AppTheme.getTextSecondary(
                                                context,
                                              ),
                                        fontWeight: sel
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(child: _currentTab),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SETTINGS APP BAR  (matches screenshot: title left, search + help + avatar right)
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceLg,
        vertical: AppTheme.spaceMd,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: AppTheme.getBorder(context), width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          // Search bar
          SizedBox(
            width: 220,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search settings...',
                hintStyle: TextStyle(
                  color: AppTheme.getTextTertiary(context),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 18,
                  color: AppTheme.getTextTertiary(context),
                ),
                filled: true,
                fillColor: AppTheme.getSurfaceVariant(context),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: AppTheme.borderRadiusXl,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppTheme.borderRadiusXl,
                  borderSide: BorderSide(color: AppTheme.getBorder(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppTheme.borderRadiusXl,
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceSm),
          // Help icon
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.help_outline_rounded,
              color: AppTheme.getTextSecondary(context),
            ),
          ),
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'AT',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LEFT SETTINGS NAV  (matches sidebar in screenshot)
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _SettingsNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class _SettingsNav extends StatelessWidget {
  final List<_SettingsNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _SettingsNav({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppTheme.getBorder(context), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spaceXs),
          ...List.generate(items.length, (i) {
            final item = items[i];
            final sel = selectedIndex == i;
            return _SettingsNavRow(
              icon: sel ? item.selectedIcon : item.icon,
              label: item.label,
              isSelected: sel,
              onTap: () => onTap(i),
            );
          }),
          const Spacer(),
          // Bottom links matching screenshot
          _SettingsNavRow(
            icon: Icons.help_outline_rounded,
            label: 'Help',
            isSelected: false,
            onTap: () {},
          ),
          const SizedBox(height: AppTheme.space2xs),
          _SettingsNavRow(
            icon: Icons.logout_rounded,
            label: 'Logout',
            isSelected: false,
            onTap: () {},
            color: AppTheme.warning,
          ),
          const SizedBox(height: AppTheme.spaceSm),
          // CTA button at bottom
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadiusMd,
                ),
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
              ),
              child: const Text(
                'Start your own Org',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsNavRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _SettingsNavRow({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  State<_SettingsNavRow> createState() => _SettingsNavRowState();
}

class _SettingsNavRowState extends State<_SettingsNavRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final color =
        widget.color ??
        (widget.isSelected ? primary : AppTheme.getTextSecondary(context));

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(vertical: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceSm,
            vertical: AppTheme.spaceSm,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? primary.withOpacity(0.08)
                : _hovered
                ? AppTheme.getSurfaceVariant(context)
                : Colors.transparent,
            borderRadius: AppTheme.borderRadiusMd,
            // Right-accent bar on selected — matches PremiumSidebar style
            border: widget.isSelected
                ? Border(right: BorderSide(color: primary, width: 3))
                : null,
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: color),
              const SizedBox(width: AppTheme.spaceSm),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

/// Standard card wrapper used across all setting sections
class _SettingsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _SettingsCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppTheme.spaceLg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppTheme.borderRadiusLg,
        border: Border.all(color: AppTheme.getBorder(context), width: 1),
      ),
      child: child,
    );
  }
}

/// Section title + optional subtitle + optional trailing action
class _SectionHeader extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SectionHeader({
    this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppTheme.getTextSecondary(context)),
          const SizedBox(width: AppTheme.spaceXs),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppTheme.space2xs),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Labeled text field matching the screenshot style
class _SettingsField extends StatelessWidget {
  final String label;
  final String value;
  final bool readOnly;

  const _SettingsField({
    required this.label,
    required this.value,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.getTextTertiary(context),
            letterSpacing: 0.8,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppTheme.space2xs),
        TextFormField(
          initialValue: value,
          readOnly: readOnly,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? AppTheme.getSurfaceVariant(context)
                : Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMd,
              vertical: AppTheme.spaceSm,
            ),
            border: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusMd,
              borderSide: BorderSide(color: AppTheme.getBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusMd,
              borderSide: BorderSide(color: AppTheme.getBorder(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppTheme.borderRadiusMd,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Row with label, optional subtitle, and trailing widget (toggle, badge, arrow)
class _SettingsRow extends StatefulWidget {
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    this.leadingIcon,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spaceMd,
            vertical: AppTheme.spaceMd,
          ),
          decoration: BoxDecoration(
            color: _hovered && widget.onTap != null
                ? AppTheme.getSurfaceVariant(context)
                : Theme.of(context).cardColor,
            borderRadius: AppTheme.borderRadiusMd,
            border: Border.all(color: AppTheme.getBorder(context), width: 1),
          ),
          child: Row(
            children: [
              if (widget.leadingIcon != null) ...[
                Icon(
                  widget.leadingIcon,
                  size: 20,
                  color: AppTheme.getTextSecondary(context),
                ),
                const SizedBox(width: AppTheme.spaceMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              widget.trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Small colored badge (ADMIN, INSTRUCTOR, Enabled, etc.)
class _Badge extends StatelessWidget {
  final String label;
  final Color? color;

  const _Badge({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c,
        borderRadius: AppTheme.borderRadiusSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 0 — GENERAL  (matches screenshot exactly)
// ═══════════════════════════════════════════════════════════════════════════════

class _GeneralTab extends StatefulWidget {
  const _GeneralTab();

  @override
  State<_GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<_GeneralTab> {
  bool _darkMode = false;
  bool _notifyCourses = true;
  bool _notifyAi = true;
  String _language = 'English (US)';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _leftContent()),
                    const SizedBox(width: AppTheme.spaceLg),
                    SizedBox(width: 280, child: _rightContent()),
                  ],
                )
              : Column(
                  children: [
                    _leftContent(),
                    const SizedBox(height: AppTheme.spaceLg),
                    _rightContent(),
                  ],
                );
        },
      ),
    );
  }

  Widget _leftContent() {
    return Column(
      children: [
        // ── Profile Information card ────────────────────────────────────
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                title: 'Profile Information',
                subtitle:
                    'Update your personal details and how others see you on the platform.',
                trailing: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceLg,
                      vertical: AppTheme.spaceMd,
                    ),
                  ),
                  child: const Text(
                    'Update\nProfile',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Profile form card (inner)
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceVariant(context),
                  borderRadius: AppTheme.borderRadiusMd,
                  border: Border.all(color: AppTheme.getBorder(context)),
                ),
                child: Column(
                  children: [
                    // Avatar row
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: AppTheme.getSurfaceVariant(context),
                                borderRadius: AppTheme.borderRadiusLg,
                                border: Border.all(
                                  color: AppTheme.getBorder(context),
                                ),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 36,
                                color: AppTheme.getTextTertiary(context),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceLg),

                    // Fields row
                    Row(
                      children: const [
                        Expanded(
                          child: _SettingsField(
                            label: 'FULL NAME',
                            value: 'Alex Thompson',
                          ),
                        ),
                        SizedBox(width: AppTheme.spaceMd),
                        Expanded(
                          child: _SettingsField(
                            label: 'EMAIL ADDRESS',
                            value: 'alex.t@htoochoon.edu',
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

        const SizedBox(height: AppTheme.spaceLg),

        // ── My Organizations card ───────────────────────────────────────
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(
                title: 'My Organizations',
                subtitle: 'Manage your institutional roles and associations.',
                trailing: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Start your own Organization',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceMd,
                      vertical: AppTheme.spaceSm,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spaceLg),

              // Org tiles grid
              Row(
                children: [
                  Expanded(
                    child: _OrgCard(
                      icon: Icons.school_outlined,
                      name: 'Global Design Academy',
                      meta: '1,240 active students',
                      role: 'ADMIN',
                      roleColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  Expanded(
                    child: _OrgCard(
                      icon: Icons.code,
                      name: 'Modern Code Labs',
                      meta: '85 active students',
                      role: 'INSTRUCTOR',
                      roleColor: const Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rightContent() {
    return Column(
      children: [
        // ── Preferences card ──────────────────────────────────────────
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(icon: Icons.tune_rounded, title: 'Preferences'),
              const SizedBox(height: AppTheme.spaceMd),

              // Dark mode row
              _SettingsRow(
                title: 'Dark Mode',
                subtitle: 'Switch to dark interface',
                trailing: Switch(
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spaceMd),

              // Language dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Language',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.getTextSecondary(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  DropdownButtonFormField<String>(
                    value: _language,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spaceMd,
                        vertical: AppTheme.spaceSm,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: AppTheme.borderRadiusMd,
                        borderSide: BorderSide(
                          color: AppTheme.getBorder(context),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppTheme.borderRadiusMd,
                        borderSide: BorderSide(
                          color: AppTheme.getBorder(context),
                        ),
                      ),
                    ),
                    items: ['English (US)', 'Myanmar', 'Chinese', 'Japanese']
                        .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                        .toList(),
                    onChanged: (v) => setState(() => _language = v!),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spaceMd),

              // Notify me about
              Text(
                'Notify me about',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextSecondary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppTheme.spaceXs),
              _CheckRow(
                label: 'New course materials',
                value: _notifyCourses,
                onChanged: (v) => setState(() => _notifyCourses = v),
              ),
              const SizedBox(height: AppTheme.spaceXs),
              _CheckRow(
                label: 'AI performance insights',
                value: _notifyAi,
                onChanged: (v) => setState(() => _notifyAi = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.spaceMd),

        // ── Security card ─────────────────────────────────────────────
        _SettingsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(icon: Icons.shield_outlined, title: 'Security'),
              const SizedBox(height: AppTheme.spaceMd),
              _SettingsRow(
                leadingIcon: Icons.lock_outline_rounded,
                title: 'Change Password',
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () {},
              ),
              const SizedBox(height: AppTheme.spaceSm),
              _SettingsRow(
                title: '2FA Authentication',
                subtitle:
                    'Two-factor authentication adds an extra layer of security to your account.',
                trailing: const _Badge(
                  label: 'Enabled',
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.spaceMd),

        // ── AI Security Insight card ──────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: AppTheme.borderRadiusLg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  const SizedBox(width: AppTheme.spaceXs),
                  Text(
                    'AI SECURITY INSIGHT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceSm),
              Text(
                'Your profile is 85% secure. Complete your bio and verification to reach 100%.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Org card (used in General tab) ───────────────────────────────────────────

class _OrgCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String meta;
  final String role;
  final Color roleColor;

  const _OrgCard({
    required this.icon,
    required this.name,
    required this.meta,
    required this.role,
    required this.roleColor,
  });

  @override
  State<_OrgCard> createState() => _OrgCardState();
}

class _OrgCardState extends State<_OrgCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        decoration: BoxDecoration(
          color: _hovered
              ? AppTheme.getSurfaceVariant(context)
              : Theme.of(context).cardColor,
          borderRadius: AppTheme.borderRadiusMd,
          border: Border.all(color: AppTheme.getBorder(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.roleColor.withOpacity(0.12),
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                  child: Icon(widget.icon, color: widget.roleColor, size: 22),
                ),
                _Badge(label: widget.role, color: widget.roleColor),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSm),
            Text(
              widget.name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppTheme.space2xs),
            Text(
              widget.meta,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.getTextSecondary(context),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Checkbox row ──────────────────────────────────────────────────────────────

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v!),
            activeColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: AppTheme.spaceXs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.getTextSecondary(context),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 1 — PROFILE
// ═══════════════════════════════════════════════════════════════════════════════

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        children: [
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Public Profile',
                  subtitle: 'This is how others see you across the platform.',
                ),
                const SizedBox(height: AppTheme.spaceLg),
                // Avatar upload
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'AT',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppTheme.spaceLg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Thompson',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Student · Global Design Academy',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.getTextSecondary(context),
                              ),
                        ),
                        const SizedBox(height: AppTheme.spaceXs),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.upload, size: 14),
                          label: const Text(
                            'Upload Photo',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppTheme.borderRadiusMd,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spaceMd,
                              vertical: AppTheme.spaceXs,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceLg),
                const Row(
                  children: [
                    Expanded(
                      child: _SettingsField(
                        label: 'FULL NAME',
                        value: 'Alex Thompson',
                      ),
                    ),
                    SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: _SettingsField(label: 'USERNAME', value: 'alex.t'),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMd),
                const Row(
                  children: [
                    Expanded(
                      child: _SettingsField(
                        label: 'EMAIL ADDRESS',
                        value: 'alex.t@htoochoon.edu',
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: _SettingsField(
                        label: 'PHONE NUMBER',
                        value: '+1 (555) 000-0000',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMd),
                const _SettingsField(
                  label: 'BIO',
                  value: 'Learning enthusiast and aspiring designer.',
                ),
                const SizedBox(height: AppTheme.spaceLg),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMd,
                      ),
                    ),
                    child: const Text('Save Changes'),
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

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 2 — ORGANIZATIONS
// ═══════════════════════════════════════════════════════════════════════════════

class _OrganizationsTab extends StatelessWidget {
  const _OrganizationsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        children: [
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'My Organizations',
                  subtitle: 'Manage your roles and institutional associations.',
                  trailing: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      'Create New',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadiusMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceLg),
                _OrgListTile(
                  icon: Icons.school_outlined,
                  name: 'Global Design Academy',
                  meta: '1,240 active students',
                  role: 'ADMIN',
                  roleColor: Theme.of(context).colorScheme.primary,
                  onTap: () {},
                ),
                const SizedBox(height: AppTheme.spaceSm),
                _OrgListTile(
                  icon: Icons.code,
                  name: 'Modern Code Labs',
                  meta: '85 active students',
                  role: 'INSTRUCTOR',
                  roleColor: const Color(0xFF0D9488),
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Invitations',
                  subtitle: 'Pending organization invitations.',
                ),
                const SizedBox(height: AppTheme.spaceMd),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  decoration: BoxDecoration(
                    color: AppTheme.getSurfaceVariant(context),
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline_rounded,
                        color: AppTheme.getTextTertiary(context),
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      Text(
                        'No pending invitations',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getTextSecondary(context),
                        ),
                      ),
                    ],
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

class _OrgListTile extends StatefulWidget {
  final IconData icon;
  final String name;
  final String meta;
  final String role;
  final Color roleColor;
  final VoidCallback onTap;

  const _OrgListTile({
    required this.icon,
    required this.name,
    required this.meta,
    required this.role,
    required this.roleColor,
    required this.onTap,
  });

  @override
  State<_OrgListTile> createState() => _OrgListTileState();
}

class _OrgListTileState extends State<_OrgListTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.getSurfaceVariant(context)
                : Theme.of(context).cardColor,
            borderRadius: AppTheme.borderRadiusMd,
            border: Border.all(color: AppTheme.getBorder(context)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.roleColor.withOpacity(0.12),
                  borderRadius: AppTheme.borderRadiusMd,
                ),
                child: Icon(widget.icon, color: widget.roleColor, size: 22),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.meta,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              _Badge(label: widget.role, color: widget.roleColor),
              const SizedBox(width: AppTheme.spaceXs),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppTheme.getTextTertiary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 3 — SECURITY
// ═══════════════════════════════════════════════════════════════════════════════

class _SecurityTab extends StatefulWidget {
  const _SecurityTab();

  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  bool _twoFa = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        children: [
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Use a strong password you don\'t use elsewhere.',
                ),
                const SizedBox(height: AppTheme.spaceLg),
                const _SettingsField(label: 'CURRENT PASSWORD', value: ''),
                const SizedBox(height: AppTheme.spaceMd),
                const Row(
                  children: [
                    Expanded(
                      child: _SettingsField(label: 'NEW PASSWORD', value: ''),
                    ),
                    SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: _SettingsField(
                        label: 'CONFIRM PASSWORD',
                        value: '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceLg),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                  ),
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  icon: Icons.shield_outlined,
                  title: '2FA Authentication',
                  subtitle: 'Add an extra layer of security to your account.',
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _SettingsRow(
                  title: 'Two-Factor Authentication',
                  subtitle: 'Require a code each time you sign in.',
                  trailing: Switch(
                    value: _twoFa,
                    onChanged: (v) => setState(() => _twoFa = v),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  icon: Icons.devices_outlined,
                  title: 'Active Sessions',
                  subtitle: 'Devices currently signed in to your account.',
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _SessionRow(
                  device: 'MacBook Pro · Chrome',
                  location: 'Yangon, Myanmar · Current session',
                  isCurrent: true,
                ),
                const SizedBox(height: AppTheme.spaceSm),
                _SessionRow(
                  device: 'iPhone 15 · Safari',
                  location: 'Yangon, Myanmar · 2 hours ago',
                  isCurrent: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final String device;
  final String location;
  final bool isCurrent;

  const _SessionRow({
    required this.device,
    required this.location,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceVariant(context),
        borderRadius: AppTheme.borderRadiusMd,
        border: Border.all(color: AppTheme.getBorder(context)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.computer_rounded,
            size: 20,
            color: AppTheme.getTextSecondary(context),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(context),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrent)
            _Badge(label: 'Current', color: const Color(0xFF16A34A))
          else
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.warning,
                padding: EdgeInsets.zero,
              ),
              child: const Text('Revoke', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TAB 4 — NOTIFICATIONS
// ═══════════════════════════════════════════════════════════════════════════════

class _NotificationsTab extends StatefulWidget {
  const _NotificationsTab();

  @override
  State<_NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<_NotificationsTab> {
  bool _courseUpdates = true;
  bool _aiInsights = true;
  bool _liveAlerts = true;
  bool _weeklyReport = false;
  bool _emailDigest = true;
  bool _pushNotifs = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        children: [
          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  icon: Icons.notifications_outlined,
                  title: 'In-App Notifications',
                  subtitle:
                      'Choose what you\'re notified about inside the platform.',
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _SwitchRow(
                  label: 'New course materials',
                  value: _courseUpdates,
                  onChanged: (v) => setState(() => _courseUpdates = v),
                ),
                _SwitchRow(
                  label: 'AI performance insights',
                  value: _aiInsights,
                  onChanged: (v) => setState(() => _aiInsights = v),
                ),
                _SwitchRow(
                  label: 'Live class reminders',
                  value: _liveAlerts,
                  onChanged: (v) => setState(() => _liveAlerts = v),
                ),
                _SwitchRow(
                  label: 'Weekly progress report',
                  value: _weeklyReport,
                  onChanged: (v) => setState(() => _weeklyReport = v),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spaceLg),

          _SettingsCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(
                  icon: Icons.email_outlined,
                  title: 'Email & Push',
                  subtitle: 'Manage external notification channels.',
                ),
                const SizedBox(height: AppTheme.spaceMd),
                _SwitchRow(
                  label: 'Email digest (weekly)',
                  value: _emailDigest,
                  onChanged: (v) => setState(() => _emailDigest = v),
                ),
                _SwitchRow(
                  label: 'Push notifications',
                  value: _pushNotifs,
                  onChanged: (v) => setState(() => _pushNotifs = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatefulWidget {
  ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _pickedImage;
  bool _isUploadingImage = false;

  final ImagePicker _picker = ImagePicker();

  // Future<void> _pickProfileImage(UserProvider provider) async {
  //   final XFile? file = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 75,
  //   );
  //
  //   if (file == null) return;
  //
  //   setState(() {
  //     _pickedImage = File(file.path);
  //   });
  //
  //   await _uploadProfileImage(provider);
  // }

  Future<void> _uploadProfileImage(UserProvider provider) async {
    if (_pickedImage == null) return;

    try {
      setState(() => _isUploadingImage = true);

      await provider.updateProfilePhoto(_pickedImage!);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
          _pickedImage = null;
        });
      }
    }
  }

  // void _showEditNameDialog(
  //   BuildContext context,
  //   AuthProvider provider,
  //   Map<String, dynamic> user,
  // ) {
  //   final controller = TextEditingController(
  //     text: user['name'] ?? user['username'],
  //   );
  //
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('Edit Name'),
  //       content: TextField(
  //         controller: controller,
  //         decoration: const InputDecoration(labelText: 'Full Name'),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: const Text('Cancel'),
  //         ),
  //         const SizedBox(width: AppTheme.spaceXs),
  //         ElevatedButton(
  //           onPressed: () async {
  //             if (controller.text.trim().isEmpty) return;
  //
  //             await provider.updateProfile(name: controller.text.trim());
  //             if (ctx.mounted) Navigator.pop(ctx);
  //           },
  //           child: const Text('Save'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (authProvider.isLoading && user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
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
      );
    }

    final String displayName = user.name;
    final String? photoUrl =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ5ExGEHlPHckD3YbxH6e4kr25Ho2X4NifiQA&s";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'My Profile',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.1),
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (photoUrl != null ? NetworkImage(photoUrl) : null)
                            as ImageProvider?,
                  child: photoUrl == null && _pickedImage == null
                      ? Text(
                          displayName[0].toUpperCase(),
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        )
                      : null,
                ),

                // Camera Button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUploadingImage ? null : () {},
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spaceXs),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 3,
                        ),
                      ),
                      child: _isUploadingImage
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceLg),

            // Name
            Text(
              displayName,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: AppTheme.space2xs),

            // Email
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.getTextSecondary(context),
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Plan Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppTheme.borderRadiusLg,
                border: Border.all(
                  color: AppTheme.getBorder(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spaceXs),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFF8B5CF6),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.getTextSecondary(context),
                              ),
                        ),
                        const SizedBox(height: AppTheme.space2xs),
                        Text(
                          ('Free').toString().toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Upgrade')),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Edit Name Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Edit Name'),
                onPressed: () {
                  // _showEditNameDialog(context, authProvider, user),
                },
              ),
            ),

            const SizedBox(height: AppTheme.spaceMd),

            // Account Settings Section
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppTheme.borderRadiusLg,
                border: Border.all(
                  color: AppTheme.getBorder(context),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Settings',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  _SettingItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: user.email ?? '',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppTheme.getBorder(context)),
                  _SettingItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: '••••••••',
                    onTap: () {},
                  ),
                  Divider(height: 1, color: AppTheme.getBorder(context)),
                  _SettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage preferences',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.space2xl),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, size: 20),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: const BorderSide(color: AppTheme.error, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadiusMd,
                  ),
                ),
                onPressed: () => _showLogoutDialog(context, authProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusMd),
        icon: Icon(Icons.logout_rounded, size: 48, color: AppTheme.error),
        title: const Text('Log Out', textAlign: TextAlign.center),
        content: const Text(
          'Are you sure you want to log out?',
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppTheme.spaceSm),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await authProvider.logout();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PremiumLoginScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadiusMd,
                    ),
                  ),
                  child: const Text('Log Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.getTextSecondary(context)),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xs),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppTheme.getTextTertiary(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
