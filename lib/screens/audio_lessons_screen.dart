import 'package:flutter/material.dart';
import '../data/audio_lessons.dart';
import '../utils/app_colors.dart';
import 'audio_player_screen.dart';

class AudioLessonsScreen extends StatelessWidget {
  const AudioLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const chapters = [
      _Chapter(
        number: '1-bob',
        title: 'Tariqatlarning shakllanish tarixi',
        lessons: bob1Audios,
      ),
      _Chapter(
        number: '2-bob',
        title: 'Tariqatlarning mintaqalar bo\'yicha xususiyatlari',
        lessons: bob2Audios,
      ),
      _Chapter(
        number: '3-bob',
        title: 'Globallashuv va tariqatlar',
        lessons: bob3Audios,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: const Text(
          'Audio qo\'llanmalar',
          textScaler: TextScaler.linear(1.0),
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 16),
            child: Text(
              'Islomshunoslik audio qo\'llanmalar',
              textScaler: TextScaler.linear(1.0),
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...chapters.map((c) => _ChapterCard(chapter: c)),
        ],
      ),
    );
  }
}

class _Chapter {
  final String number;
  final String title;
  final List<AudioLesson> lessons;
  const _Chapter({
    required this.number,
    required this.title,
    required this.lessons,
  });
}

class _ChapterCard extends StatelessWidget {
  final _Chapter chapter;
  const _ChapterCard({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final stroke = AppColors.stroke(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AudioPlayerScreen(
                  chapterTitle: chapter.number,
                  chapterSubtitle: chapter.title,
                  lessons: chapter.lessons,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.panelBg(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: stroke.withValues(alpha: 0.45), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: stroke.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.panelBg(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: stroke, width: 1.4),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.primaryGreen.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.headphones_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.number,
                          textScaler: const TextScaler.linear(1.0),
                          style: TextStyle(
                            color: AppColors.primaryGreen.withValues(alpha: 0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter.title,
                          textScaler: const TextScaler.linear(1.0),
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${chapter.lessons.length} ta audio dars',
                          textScaler: const TextScaler.linear(1.0),
                          style: TextStyle(
                            color: AppColors.secondaryText(context),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: AppColors.primaryGreen.withValues(alpha: 0.7),
                      size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}