import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/category_icons.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/apple_button.dart';
import '../../../core/widgets/apple_text_field.dart';
import '../data/incident_model.dart';

class NewReportScreen extends ConsumerStatefulWidget {
  const NewReportScreen({super.key});

  @override
  ConsumerState<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends ConsumerState<NewReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationDetailController = TextEditingController();

  String? _selectedCategory;
  String? _selectedLocation;
  File? _photo;
  bool _isUrgent = false;
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  int _descriptionLength = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationDetailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Photo Library'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 80,
    );
    if (picked != null) {
      final file = File(picked.path);
      final size = await file.length();
      if (size > AppConstants.maxImageSizeBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image must be under 5 MB.')),
          );
        }
        return;
      }
      setState(() => _photo = file);
    }
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(builder: (ctx, setSheetState) {
          final filtered = AppConstants.campusLocations
              .where((l) => l.toLowerCase().contains(search.toLowerCase()))
              .toList();
          return SafeArea(
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              minChildSize: 0.4,
              expand: false,
              builder: (_, controller) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Column(
                      children: [
                        Container(
                          width: 36, height: 4,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (v) => setSheetState(() => search = v),
                          decoration: const InputDecoration(
                            hintText: 'Search locations',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(filtered[i]),
                        trailing: _selectedLocation == filtered[i]
                            ? const Icon(Icons.check, color: AppColors.statusResolved)
                            : null,
                        onTap: () {
                          setState(() => _selectedLocation = filtered[i]);
                          Navigator.pop(ctx);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _submit() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) return;

      final repo = ref.read(incidentRepositoryProvider);
      String? photoUrl;
      if (_photo != null) {
        photoUrl = await repo.uploadPhoto(user.uid, _photo!);
      }

      final incident = IncidentModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        location: _selectedLocation!,
        locationDetail: _locationDetailController.text.trim().isNotEmpty
            ? _locationDetailController.text.trim()
            : null,
        photoUrl: photoUrl,
        priority: _isUrgent ? 'urgent' : 'normal',
        isAnonymous: _isAnonymous,
        status: 'Submitted',
        reporterId: user.uid,
        reporterName: user.fullName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.createIncident(incident);

      if (mounted) {
        HapticFeedback.heavyImpact();
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: AppColors.statusResolved),
            const SizedBox(height: 16),
            const Text('Report Submitted', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'Your report has been submitted and will be reviewed by campus staff.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: AppColors.lightSecondaryText),
            ),
            const SizedBox(height: 20),
            AppleButton(
              label: 'Done',
              onPressed: () {
                Navigator.pop(ctx);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final primaryText = isLight ? AppColors.lightPrimaryText : AppColors.darkPrimaryText;
    final secondaryText = isLight ? AppColors.lightSecondaryText : AppColors.darkSecondaryText;
    final accent = isLight ? AppColors.lightAccent : AppColors.darkAccent;
    final borderColor = isLight ? AppColors.lightBorder : AppColors.darkBorder;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => context.pop(),
        ),
        title: const Text('New Report'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Category grid
                Text('Category', style: AppTypography.secondary(secondaryText)),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                  children: AppConstants.incidentCategories.map((cat) {
                    final selected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? accent : borderColor,
                            width: selected ? 1.5 : 0.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CategoryIcons.forCategory(cat),
                              size: 26,
                              color: selected ? accent : primaryText,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                color: selected ? accent : primaryText,
                              ),
                            ),
                            if (selected) ...[
                              const SizedBox(height: 2),
                              Icon(Icons.check_circle, size: 14, color: accent),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                AppleTextField(
                  controller: _titleController,
                  hint: 'Title',
                  validator: Validators.incidentTitle,
                  maxLength: AppConstants.titleMaxLength,
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 14),
                AppleTextField(
                  controller: _descriptionController,
                  hint: 'Describe the issue in detail',
                  validator: Validators.incidentDescription,
                  maxLines: 4,
                  maxLength: AppConstants.descriptionMaxLength,
                  onChanged: (v) => setState(() => _descriptionLength = v.length),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$_descriptionLength / ${AppConstants.descriptionMaxLength}',
                      style: TextStyle(fontSize: 12, color: secondaryText),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                // Location
                GestureDetector(
                  onTap: _showLocationPicker,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'Select location',
                      suffixIcon: const Icon(Icons.chevron_right, size: 20),
                    ),
                    child: Text(
                      _selectedLocation ?? 'Select location',
                      style: TextStyle(
                        fontSize: 17,
                        color: _selectedLocation != null ? primaryText : (isLight ? AppColors.lightTertiaryText : AppColors.darkTertiaryText),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                AppleTextField(
                  controller: _locationDetailController,
                  hint: 'Room / details (optional)',
                  textInputAction: TextInputAction.done,
                ),

                // Photo
                const SizedBox(height: 20),
                Text('Photo (optional)', style: AppTypography.secondary(secondaryText)),
                const SizedBox(height: 8),
                if (_photo != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(_photo!, height: 200, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _photo = null),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 28, color: secondaryText),
                          const SizedBox(height: 6),
                          Text('Add Photo', style: TextStyle(fontSize: 15, color: secondaryText)),
                        ],
                      ),
                    ),
                  ),

                // Toggles
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile.adaptive(
                        title: Text('Urgent', style: TextStyle(fontSize: 16, color: primaryText)),
                        subtitle: Text('Mark as high priority', style: TextStyle(fontSize: 13, color: secondaryText)),
                        value: _isUrgent,
                        onChanged: (v) => setState(() => _isUrgent = v),
                      ),
                      Divider(height: 0.5, thickness: 0.5, color: borderColor, indent: 16),
                      SwitchListTile.adaptive(
                        title: Text('Anonymous', style: TextStyle(fontSize: 16, color: primaryText)),
                        subtitle: Text('Hide your name from students', style: TextStyle(fontSize: 13, color: secondaryText)),
                        value: _isAnonymous,
                        onChanged: (v) => setState(() => _isAnonymous = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                AppleButton(
                  label: 'Submit Report',
                  onPressed: _submit,
                  isLoading: _isSubmitting,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
