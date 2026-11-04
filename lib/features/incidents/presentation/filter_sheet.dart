import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class FilterSheet extends StatefulWidget {
  final String? selectedStatus;
  final String? selectedCategory;
  final Function(String? status, String? category) onApply;
  const FilterSheet({super.key, this.selectedStatus, this.selectedCategory, required this.onApply});
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late String? _status = widget.selectedStatus;
  late String? _category = widget.selectedCategory;
  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;

    return Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: ['Submitted', 'In Progress', 'Resolved', 'Rejected']
          .map((s) => ChoiceChip(label: Text(s), selected: _status == s, onSelected: (v) => setState(() => _status = v ? s : null))).toList()),
      const SizedBox(height: 16),
      const Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, children: AppConstants.incidentCategories
          .map((c) => ChoiceChip(label: Text(c), selected: _category == c, onSelected: (v) => setState(() => _category = v ? c : null))).toList()),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: () => setState(() { _status = null; _category = null; }), child: const Text('Clear'))),
        const SizedBox(width: 12),
        Expanded(child: FilledButton(onPressed: () { widget.onApply(_status, _category); Navigator.pop(context); },
            style: FilledButton.styleFrom(backgroundColor: accent), child: const Text('Apply'))),
      ]),
      const SizedBox(height: 12),
    ]));
  }
}
