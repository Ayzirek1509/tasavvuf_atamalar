import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_colors.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  List<String> recents = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recents = prefs.getStringList('recents') ?? [];
      loading = false;
    });
  }

  Future<void> _clearRecents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recents');
    setState(() => recents.clear());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Oxirgi ko‘rilganlar tozalandi')),
    );
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
          'Oxirgi ko‘rilganlar',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (recents.isNotEmpty)
            IconButton(
              onPressed: _clearRecents,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : recents.isEmpty
              ? const _EmptyRecent()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  itemCount: recents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.panelBg(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.stroke(context).withValues(alpha: 0.35),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.stroke(context).withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                                AppColors.primaryGreen.withValues(alpha: 0.12),
                            child: const Icon(
                              Icons.history_rounded,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              recents[index],
                              style: TextStyle(
                                color: AppColors.mainText(context),
                                fontSize: 18,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _EmptyRecent extends StatelessWidget {
  const _EmptyRecent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off_rounded,
              size: 76,
              color: AppColors.primaryGreen.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 18),
            const Text(
              'Hali atamalar ko‘rilmagan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Atamalarni ochsangiz, ular shu yerda saqlanadi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText(context),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}