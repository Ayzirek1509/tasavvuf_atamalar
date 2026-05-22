import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/json_loader.dart';
import 'audio_lessons_screen.dart';
import 'term_detail_screen.dart';
import 'term_list_screen.dart' show TermItem;

/// Tariqatlar va Tasavvuf haqida uchun.
/// Qidiruv yo'q, islamic naqsh fon, kartochka dizayn.
/// Tasavvuf haqida sahifasida pastda audio bo'limi.
class InfoListScreen extends StatefulWidget {
  final String title;
  final String jsonPath;
  final bool showAudioSection;

  const InfoListScreen({
    super.key,
    required this.title,
    required this.jsonPath,
    this.showAudioSection = false,
  });

  @override
  State<InfoListScreen> createState() => _InfoListScreenState();
}

class _InfoListScreenState extends State<InfoListScreen> {
  List<TermItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await JsonLoader.loadInfo(widget.jsonPath);
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('JSON yuklashda xato: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: Text(
          widget.title,
          textScaler: const TextScaler.linear(1.0),
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Orqa fon - islamic naqsh
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.06,
                      child: CustomPaint(
                        painter: _IslamicPatternPainter(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    ...items.map((item) => _InfoCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TermDetailScreen(item: item),
                              ),
                            );
                          },
                        )),
                    if (widget.showAudioSection) ...[
                      const SizedBox(height: 8),
                      _AudioSectionCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AudioLessonsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final TermItem item;
  final VoidCallback onTap;

  const _InfoCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final stroke = AppColors.stroke(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.panelBg(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: stroke, width: 1.4),
              ),
              child: Row(
                children: [
                  // 8 qirrali yulduz icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomPaint(
                      painter: _StarPainter(color: AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item.title,
                      textScaler: const TextScaler.linear(1.0),
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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

class _AudioSectionCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AudioSectionCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen,
                  AppColors.primaryGreen.withValues(alpha: 0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.headphones_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Islomshunoslik audio qo\'llanmalar',
                          textScaler: TextScaler.linear(1.0),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3 ta bob • 36 ta audio dars',
                          textScaler: TextScaler.linear(1.0),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 8 qirrali yulduz - islamic ramz
class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 6;

    // Romb (kvadrat 45 daraja burilgan)
    final path1 = Path();
    path1.moveTo(cx - r, cy);
    path1.lineTo(cx, cy - r);
    path1.lineTo(cx + r, cy);
    path1.lineTo(cx, cy + r);
    path1.close();

    // Kvadrat
    final r2 = r * 0.85;
    final d = r2 * 0.707;
    final path2 = Path();
    path2.moveTo(cx - d, cy - d);
    path2.lineTo(cx + d, cy - d);
    path2.lineTo(cx + d, cy + d);
    path2.lineTo(cx - d, cy + d);
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Orqa fon naqshi (kichik yulduzchalar)
class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 70.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = c * spacing + (r.isEven ? 0 : spacing / 2);
        final cy = r * spacing;
        _drawStar(canvas, paint, cx, cy, 16);
      }
    }
  }

  void _drawStar(Canvas canvas, Paint paint, double cx, double cy, double r) {
    final path1 = Path();
    path1.moveTo(cx - r, cy);
    path1.lineTo(cx, cy - r);
    path1.lineTo(cx + r, cy);
    path1.lineTo(cx, cy + r);
    path1.close();

    final r2 = r * 0.85;
    final d = r2 * 0.707;
    final path2 = Path();
    path2.moveTo(cx - d, cy - d);
    path2.lineTo(cx + d, cy - d);
    path2.lineTo(cx + d, cy + d);
    path2.lineTo(cx - d, cy + d);
    path2.close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}