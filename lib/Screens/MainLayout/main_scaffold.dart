import 'package:flutter/material.dart';
import 'package:htoochoon_flutter/Notificaton/announcements_widget.dart';
import 'package:htoochoon_flutter/Notificaton/noti&emails.dart';
import 'package:htoochoon_flutter/Providers/org_provider.dart';
import 'package:htoochoon_flutter/Providers/theme_provider.dart';
import 'package:htoochoon_flutter/Providers/login_provider.dart';
import 'package:htoochoon_flutter/Screens/Classes/classes_tab.dart';
import 'package:htoochoon_flutter/Screens/Courses/courses_tab.dart';
import 'package:htoochoon_flutter/Screens/Home/home_tab.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_core_home.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/OrgMainScreens/org_dashboard_wrapper.dart';
import 'package:htoochoon_flutter/Screens/OrgScreens/org_context_loader.dart';
import 'package:htoochoon_flutter/Screens/Profile/profile_tab.dart'; // Implemented
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:htoochoon_flutter/Theme/themedata.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    HomeTab(),
    ClassesTab(),
    CoursesTab(),
    OrgContextLoader(),
    ProfileTab(),
    NotiAndEmails(),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width > 900;
    final isMobile = width < 700;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final orgProvider = context.watch<OrgProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (orgProvider.justSwitched) {
        orgProvider.clearJustSwitched();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => PremiumDashboardWrapper(
              currentOrgID: orgProvider.currentOrgId,
              currentOrgName: orgProvider.currentOrgName ?? "Htoo Choon",
            ),
          ),
          (route) => false,
        );
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          // 📱 Mobile Drawer (optional)
          drawer: isMobile
              ? Drawer(
                  child: ListView(
                    children: [
                      const DrawerHeader(child: Text("Menu")),
                      _drawerItem(Icons.home, "Home", 0),
                      _drawerItem(Icons.class_, "Classes", 1),
                      _drawerItem(Icons.school, "Courses", 2),
                      _drawerItem(Icons.business, "Organizations", 3),
                      _drawerItem(Icons.person, "Profile", 4),
                      _drawerItem(Icons.notifications, "Notifications", 5),
                    ],
                  ),
                )
              : null,

          body: Row(
            children: [
              // 🖥 Desktop Sidebar
              if (!isMobile)
                _PremiumNavigationRail(
                  isExtended: isDesktop,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  themeProvider: themeProvider,
                  loginProvider: loginProvider,
                ),

              if (!isMobile)
                VerticalDivider(
                  width: 1.2,
                  thickness: 1,
                  color: AppTheme.getBorder(context),
                ),

              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
            ],
          ),

          // 📱 Bottom Navigation for Mobile
          bottomNavigationBar: isMobile
              ? BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.class_),
                      label: "Classes",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school),
                      label: "Courses",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.business),
                      label: "Orgs",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profile",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: "Alerts",
                    ),
                  ],
                )
              : null,
        ),

        // Loading overlay
        GlobalOrgSwitchOverlay(loadingText: "Switching organization…"),
      ],
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      onTap: () {
        Navigator.pop(context);
        setState(() => _selectedIndex = index);
      },
    );
  }
}

/// Premium Navigation Rail with theme integration

class _PremiumNavigationRail extends StatelessWidget {
  final bool isExtended;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final ThemeProvider themeProvider;
  final LoginProvider loginProvider;

  const _PremiumNavigationRail({
    required this.isExtended,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.themeProvider,
    required this.loginProvider,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: isExtended ? 240 : 68, // smaller professional width
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : Theme.of(context).colorScheme.primary,
            border: Border(
              right: BorderSide(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context, isExtended),

              const SizedBox(height: 12),

              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    navigationRailTheme: NavigationRailThemeData(
                      selectedIconTheme: const IconThemeData(
                        color: Colors.white,
                        size: 22,
                      ),
                      unselectedIconTheme: IconThemeData(
                        color: Colors.white.withOpacity(0.7),
                        size: 21,
                      ),
                      selectedLabelTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      indicatorColor: Colors.white.withOpacity(0.12),
                      useIndicator: true,
                    ),
                  ),
                  child: NavigationRail(
                    extended: isExtended,
                    minExtendedWidth: 240,
                    backgroundColor: Colors.transparent,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    labelType: isExtended
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,

                    groupAlignment: -0.9, // tighter top alignment

                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.class_outlined),
                        selectedIcon: Icon(Icons.class_),
                        label: Text('Classes'),
                      ),

                      NavigationRailDestination(
                        icon: Icon(Icons.library_books_outlined),
                        selectedIcon: Icon(Icons.library_books),
                        label: Text('Courses'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.business_outlined),
                        selectedIcon: Icon(Icons.business),
                        label: Text('Org'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        selectedIcon: Icon(Icons.person),
                        label: Text('Profile'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.notifications_outlined),
                        selectedIcon: Icon(Icons.notifications),
                        label: Text('Notifications'),
                      ),
                    ],
                  ),
                ),
              ),

              Divider(height: 1, color: Colors.white.withOpacity(0.08)),

              _buildFooter(context, isExtended),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isExtended) {
    return Padding(
      padding: EdgeInsets.all(isExtended ? 18 : 12),
      child: Row(
        mainAxisAlignment: isExtended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/logos/main_logo.jpeg',
              height: 40,
            ),
          ),
          if (isExtended) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "HTOO CHOON",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Learning Platform",
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isExtended) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _FooterButton(
            icon: themeProvider.isDarkMode
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            label: "Theme",
            isExtended: isExtended,
            onTap: () => themeProvider.toggleTheme(),
          ),

          const SizedBox(height: 6),

          _FooterButton(
            icon: Icons.logout_rounded,
            label: "Logout",
            isExtended: isExtended,
            color: Colors.orange,
            onTap: () => loginProvider.logout(context),
          ),
        ],
      ),
    );
  }
}

class _FooterButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isExtended;
  final VoidCallback onTap;
  final Color? color;

  const _FooterButton({
    required this.icon,
    required this.label,
    required this.isExtended,
    required this.onTap,
    this.color,
  });

  @override
  State<_FooterButton> createState() => _FooterButtonState();
}

class _FooterButtonState extends State<_FooterButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.getTextSecondary(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppTheme.borderRadiusMd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isExtended
                  ? AppTheme.spaceMd
                  : AppTheme.spaceXs,
              vertical: AppTheme.spaceSm,
            ),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppTheme.getSurfaceVariant(context)
                  : Colors.transparent,
              borderRadius: AppTheme.borderRadiusMd,
            ),
            child: Row(
              mainAxisAlignment: widget.isExtended
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: color, size: 20),
                if (widget.isExtended) ...[
                  const SizedBox(width: AppTheme.spaceSm),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// HERE!!! Global loading overlay for organization operations
class GlobalOrgSwitchOverlay extends StatelessWidget {
  final String loadingText;

  const GlobalOrgSwitchOverlay({super.key, required this.loadingText});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrgProvider>(
      builder: (_, provider, __) {
        if (!provider.orgIsLoading) return const SizedBox.shrink();

        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(
                      'assets/lottie/networking.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  Text(
                    loadingText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _categoryLabel(BuildContext context, String title, bool isExtended) {
  if (!isExtended) return const SizedBox.shrink();

  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
