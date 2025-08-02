import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meditone/screens/animations_screen.dart';
import 'package:meditone/screens/home_screen.dart';
import 'package:meditone/screens/music_screen.dart';
import 'package:meditone/themes/app_theme.dart';
import 'package:meditone/utils/responsive_utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    AnimationsScreen(),
    MusicScreen(),
  ];

  final List<String> _titles = [
    'Meditone',
    'Animations',
    'Music',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(
            fontSize: ResponsiveUtils.getAdaptiveFontSize(context, 20),
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: ResponsiveUtils.isTablet(context) ? 28 : 24,
            ),
            onPressed: () {
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
      body: ResponsiveUtils.isDesktop(context)
          ? Row(
              children: [
                // Sidebar for desktop only
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                      right: BorderSide(
                        color: AppTheme.textTertiaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ...List.generate(_screens.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: ListTile(
                            selected: _currentIndex == index,
                            selectedTileColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: Icon(
                              _getIconForIndex(index),
                              color: _currentIndex == index
                                  ? AppTheme.primaryColor
                                  : AppTheme.textTertiaryColor,
                            ),
                            title: Text(
                              _titles[index],
                              style: TextStyle(
                                color: _currentIndex == index
                                    ? AppTheme.primaryColor
                                    : AppTheme.textPrimaryColor,
                                fontWeight: _currentIndex == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                // Main content area
                Expanded(
                  child: _screens[_currentIndex],
                ),
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: ResponsiveUtils.isDesktop(context)
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: AppTheme.backgroundColor,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: AppTheme.textTertiaryColor,
              type: ResponsiveUtils.isTablet(context)
                  ? BottomNavigationBarType.fixed
                  : BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.animation_rounded),
                  label: 'Animations',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note_rounded),
                  label: 'Music',
                ),
              ],
            ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.animation_rounded;
      case 2:
        return Icons.music_note_rounded;
      default:
        return Icons.home_rounded;
    }
  }
}
