import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/json_loader.dart';
import 'term_detail_screen.dart';
import 'term_list_screen.dart' show TermItem;

/// Tariqatlar - aylanib turuvchi rasmlar bilan
class TariqatlarScreen extends StatefulWidget {
  const TariqatlarScreen({super.key});

  @override
  State<TariqatlarScreen> createState() => _TariqatlarScreenState();
}

class _TariqatlarScreenState extends State<TariqatlarScreen> {
  List<TermItem> items = [];
  bool loading = true;

  // Har bir tariqat uchun rasmlar (3 ta rasmdan iborat)
  // assets/images/ papkasiga qo'shilgan rasmlar
  final Map<String, List<String>> _tariqatImages = {
    'Yassaviya tariqati': [
      'assets/images/yassaviya_1.jpg',
      'assets/images/yassaviya_2.jpg',
      'assets/images/yassaviya_3.jpg',
    ],
    'Kubraviylik tariqati': [
      'assets/images/kubraviya_1.jpg',
      'assets/images/kubraviya_2.jpg',
      'assets/images/kubraviya_3.jpg',
    ],
    'Naqshbandiya tariqati': [
      'assets/images/naqshbandiya_1.jpg',
      'assets/images/naqshbandiya_2.jpg',
      'assets/images/naqshbandiya_3.jpg',
    ],
  };

  // Agar rasmlar bo'lmasa fallback iconlar
  final Map<String, IconData> _tariqatIcons = {
    'Yassaviya tariqati': Icons.auto_stories_rounded,
    'Kubraviylik tariqati': Icons.brightness_5_rounded,
    'Naqshbandiya tariqati': Icons.hexagon_outlined,
  };

  final Map<String, Color> _tariqatColors = {
    'Yassaviya tariqati': const Color(0xFF1B5E20),
    'Kubraviylik tariqati': const Color(0xFF4A148C),
    'Naqshbandiya tariqati': const Color(0xFF1A237E),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await JsonLoader.loadInfo('assets/data/tariqatlar.json');
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
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
        title: const Text(
          'Tariqatlar',
          textScaler: TextScaler.linear(1.0),
          style: TextStyle(
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
                // Islamic naqsh fon
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.05,
                      child: CustomPaint(
                        painter: _IslamicPatternPainter(
                            color: AppColors.primaryGreen),
                      ),
                    ),
                  ),
                ),
                ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: items
                      .map((item) => _TariqatCard(
                            item: item,
                            images: _tariqatImages[item.title],
                            icon: _tariqatIcons[item.title] ??
                                Icons.star_rounded,
                            color: _tariqatColors[item.title] ??
                                AppColors.primaryGreen,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TermDetailScreen(item: item),
                                ),
                              );
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
    );
  }
}

class _TariqatCard extends StatefulWidget {
  final TermItem item;
  final List<String>? images;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TariqatCard({
    required this.item,
    required this.images,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_TariqatCard> createState() => _TariqatCardState();
}

class _TariqatCardState extends State<_TariqatCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stroke = AppColors.stroke(context);
    final hasImages =
        widget.images != null && widget.images!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.panelBg(context),
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: stroke.withValues(alpha: 0.4), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rasmlar slayderli joyi
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: hasImages
                        ? Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: widget.images!.length,
                                onPageChanged: (i) =>
                                    setState(() => _currentPage = i),
                                itemBuilder: (context, index) {
                                  return Image.asset(
                                    widget.images![index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) =>
                                        _FallbackImage(
                                      color: widget.color,
                                      icon: widget.icon,
                                      title: widget.item.title,
                                    ),
                                  );
                                },
                              ),
                              // Dot indicator
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.images!.length,
                                    (i) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      width: _currentPage == i ? 20 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 
                                            _currentPage == i ? 1 : 0.5),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Chap/o'ng strelkalar
                              if (widget.images!.length > 1) ...[
                                Positioned(
                                  left: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_currentPage > 0) {
                                        _pageController.previousPage(
                                          duration: const Duration(
                                              milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                          size: 22),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_currentPage <
                                          widget.images!.length - 1) {
                                        _pageController.nextPage(
                                          duration: const Duration(
                                              milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.black.withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 22),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        : _FallbackImage(
                            color: widget.color,
                            icon: widget.icon,
                            title: widget.item.title,
                          ),
                  ),
                ),
                // Pastki matn
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.title,
                              textScaler: const TextScaler.linear(1.0),
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textScaler: const TextScaler.linear(1.0),
                              style: TextStyle(
                                color: AppColors.secondaryText(context),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Batafsil',
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rasm bo'lmasa ko'rsatiladigan dizayn
class _FallbackImage extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;

  const _FallbackImage({
    required this.color,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Naqsh
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _IslamicPatternPainter(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 52),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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

class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const spacing = 60.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = c * spacing + (r.isEven ? 0 : spacing / 2);
        final cy = r * spacing;
        _drawStar(canvas, paint, cx, cy, 14);
      }
    }
  }

  void _drawStar(
      Canvas canvas, Paint paint, double cx, double cy, double r) {
    final path1 = Path()
      ..moveTo(cx - r, cy)
      ..lineTo(cx, cy - r)
      ..lineTo(cx + r, cy)
      ..lineTo(cx, cy + r)
      ..close();

    final r2 = r * 0.85;
    final d = r2 * 0.707;
    final path2 = Path()
      ..moveTo(cx - d, cy - d)
      ..lineTo(cx + d, cy - d)
      ..lineTo(cx + d, cy + d)
      ..lineTo(cx - d, cy + d)
      ..close();

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}