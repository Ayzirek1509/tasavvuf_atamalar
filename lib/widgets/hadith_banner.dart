import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/about_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/literature_screen.dart';
import '../screens/placeholder_screen.dart';
import '../utils/app_colors.dart';
import '../utils/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = AppColors.isDark(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: AppColors.panelBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const _DrawerHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 14),
                child: Column(
                  children: [
                    _DrawerItem(
                      icon: Icons.email_outlined,
                      bgColor: const Color(0xFFE3F1DC),
                      iconColor: const Color(0xFF2F80C8),
                      title: 'Murojaat',
                      onTap: () => _open(context, const ContactScreen()),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                      child: Row(
                        children: [
                          const _IconBox(
                            icon: Icons.dark_mode_outlined,
                            bgColor: Color(0xFFE8E1D9),
                            iconColor: Color(0xFF6D45C9),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Tungi ko‘rinish',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.mainText(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 0.62,
                            child: Switch(
                              value: themeProvider.isDarkMode,
                              activeThumbColor: AppColors.primaryGreen,
                              activeTrackColor: AppColors.primaryGreen,
                              inactiveThumbColor: Colors.black,
                              inactiveTrackColor: Colors.white,
                              onChanged: themeProvider.toggleTheme,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 22,
                      indent: 18,
                      endIndent: 18,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),

                    _DrawerItem(
                      icon: Icons.favorite_border_rounded,
                      bgColor: const Color(0xFFF6D9D3),
                      iconColor: const Color(0xFFD82F67),
                      title: 'Sevimlilar',
                      onTap: () => _open(
                        context,
                        const PlaceholderScreen(title: 'Sevimlilar'),
                      ),
                    ),
                    _DrawerItem(
                      icon: Icons.history_rounded,
                      bgColor: const Color(0xFFDDF0DA),
                      iconColor: const Color(0xFF1CA292),
                      title: 'Oxirgi ko‘rilganlar',
                      onTap: () => _open(
                        context,
                        const PlaceholderScreen(title: 'Oxirgi ko‘rilganlar'),
                      ),
                    ),
                    _DrawerItem(
                      icon: Icons.settings_outlined,
                      bgColor: const Color(0xFFE8EADB),
                      iconColor: const Color(0xFF607D8B),
                      title: 'Sozlamalar',
                      onTap: () => _open(
                        context,
                        const PlaceholderScreen(title: 'Sozlamalar'),
                      ),
                    ),

                    Divider(
                      height: 22,
                      indent: 18,
                      endIndent: 18,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),

                    _DrawerItem(
                      icon: Icons.info_outline,
                      bgColor: const Color(0xFFE4F0D6),
                      iconColor: const Color(0xFF2E8B57),
                      title: 'Dastur haqida',
                      onTap: () => _open(context, const AboutScreen()),
                    ),
                    _DrawerItem(
                      icon: Icons.menu_book_rounded,
                      bgColor: const Color(0xFFF5F0CF),
                      iconColor: const Color(0xFFC8A951),
                      title: 'Foydalanilgan adabiyotlar',
                      onTap: () => _open(context, const LiteratureScreen()),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Versiya 1.0.0',
                      style: TextStyle(
                        color: AppColors.secondaryText(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
      ),
      padding: const EdgeInsets.fromLTRB(22, 44, 18, 18),
      child: const Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          'Menyu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
      minLeadingWidth: 0,
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      leading: _IconBox(
        icon: icon,
        bgColor: bgColor,
        iconColor: iconColor,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15,
          color: AppColors.mainText(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _IconBox({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.isDark(context) ? AppColors.darkCream : bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 18,
      ),
    );
  }
}