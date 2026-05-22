import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/json_loader.dart';   // ⬅️ YANGI import
import 'term_detail_screen.dart';

class TermListScreen extends StatefulWidget {
  final String title;
  final String jsonPath;              // ⬅️ items O'RNIGA jsonPath
  final bool isInfoFormat;

  const TermListScreen({
    super.key,
    required this.title,
    required this.jsonPath,
    this.isInfoFormat = false,
  });

  @override
  State<TermListScreen> createState() => _TermListScreenState();
}

class _TermListScreenState extends State<TermListScreen> {
  String query = '';
  List<TermItem> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = widget.isInfoFormat
          ? await JsonLoader.loadInfo(widget.jsonPath)
          : await JsonLoader.loadTerms(widget.jsonPath);
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('JSON yuklashda xato (${widget.jsonPath}): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((item) {
      final q = query.toLowerCase();
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }).toList();

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
                  child: TextField(
                    onChanged: (value) => setState(() => query = value),
                    decoration: InputDecoration(
                      hintText: 'Qidirish...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: AppColors.isDark(context)
                          ? AppColors.darkPanel
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text('Hech narsa topilmadi'))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: AppColors.stroke(context)
                                  .withValues(alpha: 0.25)),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              title: Text(
                                item.title,
                                textScaler: const TextScaler.linear(1.0),
                                style: const TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textScaler: const TextScaler.linear(1.0),
                                style: TextStyle(
                                  color: AppColors.secondaryText(context),
                                  fontSize: 16,
                                  height: 1.35,
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.primaryGreen, size: 30),
                              onTap: () => _showDetails(context, item),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showDetails(BuildContext context, TermItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TermDetailScreen(item: item),
      ),
    );
  }
}

class TermItem {
  final String title;
  final String description;
  const TermItem(this.title, this.description);
}