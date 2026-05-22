import 'dart:math';
import 'package:flutter/material.dart';

import '../data/hadiths.dart';
import '../utils/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/menu_card.dart';
import 'books_screen.dart';
import 'info_list_screen.dart';
import 'personal_diary_screen.dart';
import 'quiz_screen.dart';
import 'tariqatlar_screen.dart';
import 'term_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, String> currentHadith;

  @override
  void initState() {
    super.initState();
    _pickRandomHadith();
  }

  void _pickRandomHadith() {
    final random = Random();
    currentHadith = hadithsList[random.nextInt(hadithsList.length)];
  }

  void _setNewHadith() => setState(_pickRandomHadith);

  void _showHadithDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            backgroundColor: AppColors.panelBg(context),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.82),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hadis',
                        textScaler: const TextScaler.linear(1.0),
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: AppColors.mainText(context))),
                    const SizedBox(height: 14),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(currentHadith['full']!,
                            textScaler: const TextScaler.linear(1.0),
                            style: TextStyle(fontSize: 17, color: AppColors.mainText(context), height: 1.45)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Yopish', style: TextStyle(color: AppColors.lightGreen, fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 6),
                        TextButton(
                          onPressed: () { _setNewHadith(); setDialogState(() {}); },
                          child: const Text('Yangi hadis', style: TextStyle(color: AppColors.lightGreen, fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.mainText(context),
        elevation: 0,
        title: Text('Ilova',
            textScaler: const TextScaler.linear(1.0),
            style: TextStyle(color: AppColors.mainText(context), fontSize: 24, fontWeight: FontWeight.w800)),
        iconTheme: IconThemeData(color: AppColors.mainText(context), size: 30),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
            child: _HadithCard(text: currentHadith['full']!, onTap: _showHadithDialog),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Menyular',
                      textScaler: const TextScaler.linear(1.0),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.mainText(context))),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.98,
                    children: [
                      MenuCard(
                        title: 'Barcha atamalar',
                        imageAsset: 'assets/images/menu_all_terms.png',
                        onTap: () => _navigateTo(const TermListScreen(title: 'Atamalar', jsonPath: 'assets/data/terms.json')),
                      ),
                      MenuCard(
                        title: 'Qur\'onda kelgan atamalar',
                        imageAsset: 'assets/images/quran_book.png',
                        onTap: () => _navigateTo(const TermListScreen(title: 'Qur\'onda kelgan atamalar', jsonPath: 'assets/data/quron_terms.json')),
                      ),
                      MenuCard(
                        title: 'Hadisda kelgan atamalar',
                        imageAsset: 'assets/images/menu_hadith_terms.png',
                        onTap: () => _navigateTo(const TermListScreen(title: 'Hadisda kelgan atamalar', jsonPath: 'assets/data/hadis_terms.json')),
                      ),
                      MenuCard(
                        title: 'Tariqatlar',
                        imageAsset: 'assets/images/menu_tariqatlar.png',
                        onTap: () => _navigateTo(const TariqatlarScreen()),
                      ),
                      MenuCard(
                        title: 'Tasavvuf haqida',
                        imageAsset: 'assets/images/menu_tasavvuf_haqida.png',
                        onTap: () => _navigateTo(const InfoListScreen(
                          title: 'Tasavvuf haqida',
                          jsonPath: 'assets/data/tasavvuf_haqqida.json',
                          showAudioSection: true,
                        )),
                      ),
                      MenuCard(
                        title: 'Tasavvufiy asarlar',
                        imageAsset: 'assets/images/menu_tasavvufiy_asarlar.png',
                        onTap: () => _navigateTo(const BooksScreen()),
                      ),
                      MenuCard(
                        title: 'Esda qolish mashqlari',
                        imageAsset: 'assets/images/menu_esda_qolish.png',
                        onTap: () => _navigateTo(const QuizScreen()),
                      ),
                      MenuCard(
                        title: 'Shaxsiy kundaligim',
                        imageAsset: 'assets/images/menu_shaxsiy_kundaligim.png',
                        onTap: () => _navigateTo(const PersonalDiaryScreen()),
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

class _HadithCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _HadithCard({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stroke = AppColors.stroke(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.panelBg(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: stroke.withValues(alpha: 0.45), width: 1.2),
            boxShadow: [BoxShadow(color: stroke.withValues(alpha: 0.22), blurRadius: 8, spreadRadius: 1, offset: const Offset(2, 4))],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: AppColors.panelBg(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: stroke, width: 1.6),
            ),
            child: Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              textScaler: const TextScaler.linear(1.0),
              style: TextStyle(fontSize: 16, color: AppColors.mainText(context), height: 1.42, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),
    );
  }
}