import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_colors.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool newsEnabled = true;
  bool hadithReminderEnabled = false;
  String selectedLanguage = 'UZ';

  final TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  /// SharedPreferences dan saqlangan qiymatlarni yuklaydi
  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hadithReminderEnabled = prefs.getBool('hadithReminderEnabled') ?? false;
    });
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> _sendFeedback() async {
    final text = feedbackController.text.trim();

    final uri = Uri(
      scheme: 'mailto',
      path: 'tajibayevaayzirek@gmail.com',
      queryParameters: {
        'subject': 'Tasavvuf Terms Feedback',
        'body': text.isEmpty
            ? 'Assalomu alaykum, ilova bo\'yicha fikr-mulohaza...'
            : text,
      },
    );

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!mounted) return;

    if (ok) {
      feedbackController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fikringiz yuborildi. Rahmat!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ilovasi ochilmadi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sozlamalar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  Color(0xFF0B6B3A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Ilova sozlamalarini o\'zingizga moslang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const _SectionTitle(title: 'Eslatmalar'),

          _SwitchTile(
            icon: Icons.campaign_outlined,
            title: 'Yangiliklar',
            subtitle: 'Yangi ma\'lumotlar haqida xabar olish',
            value: newsEnabled,
            onChanged: (value) => setState(() => newsEnabled = value),
          ),

          const SizedBox(height: 12),

          _SwitchTile(
            icon: Icons.menu_book_outlined,
            title: '40 hadis eslatmalar',
            subtitle: 'Har kuni random hadis telefon oynasida chiqadi',
            value: hadithReminderEnabled,
            onChanged: (value) async {
              setState(() => hadithReminderEnabled = value);
              await NotificationService.scheduleDailyHadithReminder(
                enabled: value,
              );
            },
          ),

          const SizedBox(height: 20),

          const _SectionTitle(title: 'Til sozlamalari'),

          _CardBox(
            child: Row(
              children: [
                const _CircleIcon(
                  icon: Icons.language_rounded,
                  color: Color(0xFF1565C0),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Ilova tili',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.mainText(context),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(16),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'UZ', child: Text('UZB')),
                      DropdownMenuItem(value: 'ENG', child: Text('ENG')),
                      DropdownMenuItem(value: 'RU', child: Text('RU')),
                      DropdownMenuItem(value: 'ARAB', child: Text('ARAB')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedLanguage = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const _SectionTitle(title: 'Fikr bildirish'),

          _CardBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    _CircleIcon(
                      icon: Icons.feedback_outlined,
                      color: Color(0xFFE67E22),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Taklif va fikrlaringiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: feedbackController,
                  minLines: 4,
                  maxLines: 6,
                  style: TextStyle(
                    color: AppColors.mainText(context),
                    fontSize: 16,
                    height: 1.4,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        'Masalan: yangi atamalar qo\'shish, dizayn yoki xatolik haqida yozing...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText(context),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: AppColors.pageBg(context),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: AppColors.stroke(context).withValues(alpha: 0.35),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                        color: AppColors.primaryGreen,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _sendFeedback,
                    icon: const Icon(Icons.send_rounded),
                    label: const Text(
                      'Yuborish',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 4,
                      shadowColor: AppColors.primaryGreen.withValues(alpha: 0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _CardBox(
            child: Row(
              children: [
                const _CircleIcon(
                  icon: Icons.info_outline_rounded,
                  color: Color(0xFF607D8B),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Ilova versiyasi',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mainText(context),
                    ),
                  ),
                ),
                const Text(
                  '1.0.0',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CardBox extends StatelessWidget {
  final Widget child;

  const _CardBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panelBg(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.stroke(context).withValues(alpha: 0.32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.stroke(context).withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CircleIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 25,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardBox(
      child: Row(
        children: [
          _CircleIcon(
            icon: icon,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textScaler: const TextScaler.linear(1.0),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.mainText(context),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  textScaler: const TextScaler.linear(1.0),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: AppColors.secondaryText(context),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primaryGreen,
            inactiveThumbColor: Colors.black,
            inactiveTrackColor: Colors.white,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}