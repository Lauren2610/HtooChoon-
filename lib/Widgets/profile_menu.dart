import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Providers/auth_provider.dart';
import 'package:htoochoon_flutter/Screens/Profile/profile_tab.dart';
import 'package:htoochoon_flutter/Theme/themedata.dart';
import 'package:provider/provider.dart';

class ProfileMenu extends StatefulWidget {
  BuildContext? context;
  ProfileMenu({super.key, this.context});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return PopupMenuButton<int>(
      tooltip: "",
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Theme.of(context).cardColor,
      onSelected: (value) {
        if (value == 1) {
          // Profile
        }
        if (value == 2) {
          // Settings
        }
        if (value == 3) {
          authProvider.logout();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 0, enabled: false, child: _ProfileHeader()),

        const PopupMenuDivider(),

        PopupMenuItem(
          value: 1,
          child: _MenuItem(
            icon: Icons.person_outline,
            label: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileMenu()),
              );
            },
          ),
        ),

        PopupMenuItem(
          value: 2,
          child: _MenuItem(
            icon: Icons.settings_outlined,
            label: "Settings",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileMenu()),
              );
            },
          ),
        ),

        const PopupMenuDivider(),

        PopupMenuItem(
          value: 3,
          child: _MenuItem(
            icon: Icons.logout,
            label: "Logout",
            isDanger: true,
            onPressed: authProvider.logout,
          ),
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppTheme.getBorder(context)),
          ),
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12"),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Admin User", style: TextStyle(fontWeight: FontWeight.w600)),
            Text(
              "admin@school.com",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;
  final VoidCallback onPressed;

  const _MenuItem({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : AppTheme.getTextTertiary(context);

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
