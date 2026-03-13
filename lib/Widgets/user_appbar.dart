import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:htoochoon_flutter/Widgets/profile_menu.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadIcon;

  const UserAppBar({super.key, this.title = '', this.leadIcon});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.space2xs),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              leadIcon ?? Icons.rocket_launch,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spaceSm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppTheme.getBorder(context)),
            ),
          ),
          icon: Icon(
            Icons.notifications_outlined,
            size: 20,
            color: AppTheme.getTextSecondary(context),
          ),
        ),

        const SizedBox(width: AppTheme.spaceXs),

        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppTheme.getBorder(context)),
            ),
          ),
          icon: Icon(
            Icons.search,
            size: 20,
            color: AppTheme.getTextSecondary(context),
          ),
        ),

        const SizedBox(width: AppTheme.spaceMd),

        ProfileMenu(),

        const SizedBox(width: AppTheme.spaceLg),
      ],
    );
  }
}
