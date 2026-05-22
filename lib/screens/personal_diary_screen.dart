import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PersonalDiaryScreen extends StatefulWidget {
  const PersonalDiaryScreen({super.key});

  @override
  State<PersonalDiaryScreen> createState() => _PersonalDiaryScreenState();
}

class _PersonalDiaryScreenState extends State<PersonalDiaryScreen> {
  final List<_TodoItem> _items = [];
  final TextEditingController _controller = TextEditingController();
  int _selectedFilter = 0; // 0=hammasi, 1=bajarilmagan, 2=bajarilgan
  String _selectedPriority = 'O\'rta';

  static const _priorities = [
    _Priority('Muhim', Color(0xFFE53935), Color(0xFFFCE4EC)),
    _Priority('O\'rta', Color(0xFFF57C00), Color(0xFFFFF3E0)),
    _Priority('Oddiy', Color(0xFF2E7D32), Color(0xFFE8F5E9)),
  ];

  List<_TodoItem> get _filtered {
    switch (_selectedFilter) {
      case 1:
        return _items.where((e) => !e.done).toList();
      case 2:
        return _items.where((e) => e.done).toList();
      default:
        return _items;
    }
  }

  void _addItem() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.insert(
        0,
        _TodoItem(
          text: text,
          priority: _selectedPriority,
          createdAt: DateTime.now(),
        ),
      );
    });
    _controller.clear();
  }

  void _deleteItem(int index) {
    final realIndex = _items.indexOf(_filtered[index]);
    setState(() => _items.removeAt(realIndex));
  }

  void _toggleDone(int index) {
    final realIndex = _items.indexOf(_filtered[index]);
    setState(() => _items[realIndex].done = !_items[realIndex].done);
  }

  Color _priorityColor(String p) {
    return _priorities.firstWhere((e) => e.label == p).color;
  }

  Color _priorityBg(String p) {
    return _priorities.firstWhere((e) => e.label == p).bg;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final doneCount = _items.where((e) => e.done).length;

    return Scaffold(
      backgroundColor: AppColors.pageBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.pageBg(context),
        foregroundColor: AppColors.primaryGreen,
        elevation: 0,
        title: const Text(
          'Shaxsiy kundaligim',
          textScaler: TextScaler.linear(1.0),
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          // Statistika
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  _StatCard(
                    label: 'Jami',
                    value: _items.length.toString(),
                    color: AppColors.primaryGreen,
                    context: context,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Bajarilgan',
                    value: doneCount.toString(),
                    color: const Color(0xFF2E7D32),
                    context: context,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Qolgan',
                    value: (_items.length - doneCount).toString(),
                    color: const Color(0xFFE53935),
                    context: context,
                  ),
                ],
              ),
            ),

          // Yangi vazifa qo'shish
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.panelBg(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.stroke(context).withValues(alpha: 0.4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prioritet tanlash
                  Row(
                    children: _priorities.map((p) {
                      final selected = _selectedPriority == p.label;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedPriority = p.label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? p.color : p.bg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: p.color.withValues(alpha: selected ? 1 : 0.4),
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              p.label,
                              style: TextStyle(
                                color: selected ? Colors.white : p.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _addItem(),
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Yangi vazifa yozing...',
                            hintStyle: TextStyle(
                              color: AppColors.secondaryText(context),
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            color: AppColors.mainText(context),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _addItem,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Hammasi',
                  selected: _selectedFilter == 0,
                  onTap: () => setState(() => _selectedFilter = 0),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Qolganlar',
                  selected: _selectedFilter == 1,
                  onTap: () => setState(() => _selectedFilter = 1),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Bajarilgan',
                  selected: _selectedFilter == 2,
                  onTap: () => setState(() => _selectedFilter = 2),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt,
                            size: 56,
                            color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                        const SizedBox(height: 12),
                        Text(
                          _items.isEmpty
                              ? 'Hali vazifalar yo\'q'
                              : 'Bu bo\'limda vazifa yo\'q',
                          style: TextStyle(
                            color: AppColors.secondaryText(context),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _TodoCard(
                        item: item,
                        priorityColor: _priorityColor(item.priority),
                        priorityBg: _priorityBg(item.priority),
                        onToggle: () => _toggleDone(index),
                        onDelete: () => _deleteItem(index),
                        context: context,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TodoItem {
  String text;
  String priority;
  bool done;
  DateTime createdAt;

  _TodoItem({
    required this.text,
    required this.priority,
    required this.createdAt,
  }) : done = false;
}

class _Priority {
  final String label;
  final Color color;
  final Color bg;
  const _Priority(this.label, this.color, this.bg);
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final BuildContext context;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryGreen
              : AppColors.panelBg(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primaryGreen
                : AppColors.stroke(context).withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : AppColors.secondaryText(context),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TodoCard extends StatelessWidget {
  final _TodoItem item;
  final Color priorityColor;
  final Color priorityBg;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final BuildContext context;

  const _TodoCard({
    required this.item,
    required this.priorityColor,
    required this.priorityBg,
    required this.onToggle,
    required this.onDelete,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Dismissible(
      key: ValueKey(item.text + item.createdAt.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline,
            color: Color(0xFFE53935), size: 26),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.done
              ? AppColors.panelBg(context).withValues(alpha: 0.5)
              : AppColors.panelBg(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.done
                ? AppColors.stroke(context).withValues(alpha: 0.2)
                : priorityColor.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: item.done
              ? []
              : [
                  BoxShadow(
                    color: priorityColor.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: item.done ? AppColors.primaryGreen : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.done
                        ? AppColors.primaryGreen
                        : priorityColor.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: item.done
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Matn
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.text,
                    style: TextStyle(
                      color: item.done
                          ? AppColors.secondaryText(context)
                          : AppColors.mainText(context),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration:
                          item.done ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.secondaryText(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: priorityBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.priority,
                          style: TextStyle(
                            color: priorityColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // O'chirish
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close,
                color: AppColors.secondaryText(context).withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}