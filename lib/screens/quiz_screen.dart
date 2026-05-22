import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, String>> _allTerms = [];
  bool _loading = true;
  int? _selectedCount;

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  Future<void> _loadTerms() async {
    try {
      final raw = await rootBundle.loadString('assets/data/terms.json');
      final List<dynamic> data = json.decode(raw);
      final list = data
          .map<Map<String, String>>((e) => {
                'term': (e['term'] ?? '').toString(),
                'definition': (e['definition'] ?? '').toString(),
              })
          .where((e) => e['term']!.isNotEmpty && e['definition']!.isNotEmpty)
          .toList();

      setState(() {
        _allTerms = list;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _startQuiz(int count) {
    setState(() => _selectedCount = count);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_selectedCount == null) {
      return _QuizSelectScreen(
        onSelect: _startQuiz,
        totalTerms: _allTerms.length,
      );
    }

    return _QuizPlayScreen(
      allTerms: _allTerms,
      count: _selectedCount!,
      onRestart: () => setState(() => _selectedCount = null),
    );
  }
}

class _QuizSelectScreen extends StatelessWidget {
  final ValueChanged<int> onSelect;
  final int totalTerms;

  const _QuizSelectScreen({
    required this.onSelect,
    required this.totalTerms,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: const Text(
          'Esda qolish mashqlari',
          textScaler: TextScaler.linear(1.0),
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test turini tanlang',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Jami $totalTerms ta atama mavjud',
              style: TextStyle(
                color: AppColors.primaryGreen.withValues(alpha: 0.7),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 32),
            _QuizOption(
              count: 10,
              label: 'Tezkor test',
              description: '10 ta savol • ~5 daqiqa',
              icon: Icons.flash_on_rounded,
              color: const Color(0xFF2E7D32),
              onTap: () => onSelect(10),
            ),
            const SizedBox(height: 16),
            _QuizOption(
              count: 20,
              label: 'O\'rtacha test',
              description: '20 ta savol • ~10 daqiqa',
              icon: Icons.school_rounded,
              color: const Color(0xFF1565C0),
              onTap: () => onSelect(20),
            ),
            const SizedBox(height: 16),
            _QuizOption(
              count: 30,
              label: 'To\'liq test',
              description: '30 ta savol • ~15 daqiqa',
              icon: Icons.emoji_events_rounded,
              color: const Color(0xFF6A1B9A),
              onTap: () => onSelect(30),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  final int count;
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuizOption({
    required this.count,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: color.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizPlayScreen extends StatefulWidget {
  final List<Map<String, String>> allTerms;
  final int count;
  final VoidCallback onRestart;

  const _QuizPlayScreen({
    required this.allTerms,
    required this.count,
    required this.onRestart,
  });

  @override
  State<_QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<_QuizPlayScreen>
    with SingleTickerProviderStateMixin {
  late List<_Question> _questions;
  int _current = 0;
  int _correct = 0;
  int? _selected;
  bool _answered = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _generateQuestions();
    _animController.forward();
  }

  /// Atama nomini ta'rifdan tozalaydi va ta'rifning qisqa ko'rinishini qaytaradi.
  /// Maqsad: ta'rifda atama nomini bevosita ko'rsatmaslik.
  String _meaningSnippet(String term, String definition) {
    // Atamaning izohi ko'pincha qavslar bilan boshlanadi: "(arab. ...) — ..."
    // Ularni olib tashlash uchun "—" yoki "-" dan keyingi qismni olamiz.
    String text = definition.trim();

    // Boshidagi qavsdagi etimologiyani olib tashlash
    if (text.startsWith('(')) {
      final closeIdx = text.indexOf(')');
      if (closeIdx > 0 && closeIdx < text.length - 1) {
        text = text.substring(closeIdx + 1).trim();
      }
    }

    // "—" yoki "–" yoki "-" dan keyingi asosiy mazmunni olamiz
    for (final sep in ['—', '–', ' - ']) {
      final idx = text.indexOf(sep);
      if (idx > 0 && idx < 30) {
        text = text.substring(idx + sep.length).trim();
        break;
      }
    }

    // Atama nomini ta'rif ichidan olib tashlash (case-insensitive almashtirish)
    final termLower = term.toLowerCase();
    final lowerText = text.toLowerCase();
    final termIdx = lowerText.indexOf(termLower);
    if (termIdx >= 0) {
      text = '${text.substring(0, termIdx)}...${text.substring(termIdx + term.length)}';
    }

    // Birinchi jumlani olish
    final dotIdx = text.indexOf('.');
    if (dotIdx > 20 && dotIdx < 180) {
      text = text.substring(0, dotIdx + 1);
    }

    // Maksimal 180 belgi
    if (text.length > 180) {
      final trimmed = text.substring(0, 180);
      final lastSpace = trimmed.lastIndexOf(' ');
      text = lastSpace > 100
          ? '${trimmed.substring(0, lastSpace)}...'
          : '$trimmed...';
    }

    return text.trim();
  }

  void _generateQuestions() {
    final random = Random();
    final terms = List.of(widget.allTerms)..shuffle(random);
    final selected = terms.take(widget.count).toList();

    _questions = selected.map((term) {
      final correctTerm = term['term']!;
      final wrongTerms = List.of(widget.allTerms)
        ..removeWhere((e) => e['term'] == correctTerm)
        ..shuffle(random);

      // Variantlar — qisqa atamalar nomi
      final wrongs = wrongTerms.take(3).map((e) => e['term']!).toList();
      final options = [...wrongs, correctTerm]..shuffle(random);
      final correctIndex = options.indexOf(correctTerm);

      // Savol — ta'rifning qisqa ko'rinishi
      final meaning = _meaningSnippet(correctTerm, term['definition']!);

      return _Question(
        term: meaning,
        correctIndex: correctIndex,
        options: options,
      );
    }).toList();
  }

  void _answer(int index) {
    if (_answered) return;

    setState(() {
      _selected = index;
      _answered = true;

      if (index == _questions[_current].correctIndex) {
        _correct++;
      }
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      _animController.reset();

      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });

      _animController.forward();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => _ResultScreen(
          correct: _correct,
          total: _questions.length,
          onRestart: widget.onRestart,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final progress = (_current + 1) / _questions.length;

    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onRestart,
        ),
        title: Text(
          '${_current + 1} / ${_questions.length}',
          textScaler: const TextScaler.linear(1.0),
          style: const TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '✅ $_correct',
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
                minHeight: 6,
              ),
            ),

            const SizedBox(height: 18),

            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Quyidagi ta\'rifga mos atamani toping:',
                      textScaler: TextScaler.linear(1.0),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      q.term,
                      textScaler: const TextScaler.linear(1.0),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: q.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    Color bgColor;
                    Color borderColor;
                    Color textColor;
                    Widget? trailingIcon;

                    if (!_answered) {
                      bgColor = AppColors.panelBg(context);
                      borderColor = AppColors.stroke(context).withValues(alpha: 0.4);
                      textColor = AppColors.mainText(context);
                    } else if (index == q.correctIndex) {
                      bgColor = const Color(0xFFE8F5E9);
                      borderColor = const Color(0xFF2E7D32);
                      textColor = const Color(0xFF2E7D32);
                      trailingIcon = const Icon(
                        Icons.check_circle,
                        color: Color(0xFF2E7D32),
                        size: 22,
                      );
                    } else if (index == _selected) {
                      bgColor = const Color(0xFFFFEBEE);
                      borderColor = const Color(0xFFE53935);
                      textColor = const Color(0xFFE53935);
                      trailingIcon = const Icon(
                        Icons.cancel,
                        color: Color(0xFFE53935),
                        size: 22,
                      );
                    } else {
                      bgColor = AppColors.panelBg(context);
                      borderColor = AppColors.stroke(context).withValues(alpha: 0.2);
                      textColor =
                          AppColors.secondaryText(context).withValues(alpha: 0.5);
                    }

                    return GestureDetector(
                      onTap: () => _answer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: borderColor.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + index),
                                  style: TextStyle(
                                    color: borderColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                q.options[index],
                                textScaler: const TextScaler.linear(1.0),
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (trailingIcon != null) ...[
                              const SizedBox(width: 8),
                              trailingIcon,
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            if (_answered)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      _current < _questions.length - 1
                          ? 'Keyingi savol →'
                          : 'Natijani ko\'rish',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String term;
  final int correctIndex;
  final List<String> options;

  const _Question({
    required this.term,
    required this.correctIndex,
    required this.options,
  });
}

class _ResultScreen extends StatelessWidget {
  final int correct;
  final int total;
  final VoidCallback onRestart;

  const _ResultScreen({
    required this.correct,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (correct / total * 100).round();

    final Color resultColor;
    final String resultText;
    final IconData resultIcon;

    if (percentage >= 80) {
      resultColor = const Color(0xFF2E7D32);
      resultText = 'Ajoyib!';
      resultIcon = Icons.emoji_events_rounded;
    } else if (percentage >= 60) {
      resultColor = const Color(0xFFF57C00);
      resultText = 'Yaxshi!';
      resultIcon = Icons.thumb_up_rounded;
    } else {
      resultColor = const Color(0xFFE53935);
      resultText = 'Ko\'proq mashq kerak';
      resultIcon = Icons.refresh_rounded;
    }

    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: resultColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: resultColor.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Icon(resultIcon, color: resultColor, size: 56),
              ),
              const SizedBox(height: 24),
              Text(
                resultText,
                style: TextStyle(
                  color: resultColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$correct / $total to\'g\'ri javob',
                style: TextStyle(
                  color: AppColors.secondaryText(context),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: correct / total,
                        strokeWidth: 12,
                        backgroundColor: resultColor.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: resultColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Qayta boshlash',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Bosh sahifaga qaytish',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}