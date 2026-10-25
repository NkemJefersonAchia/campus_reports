import 'package:flutter/material.dart';

class PhotoSourceSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  const PhotoSourceSheet({super.key, required this.onCamera, required this.onGallery});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(leading: const Icon(Icons.camera_alt_outlined), title: const Text('Take Photo'),
            onTap: () { Navigator.pop(context); onCamera(); }),
          ListTile(leading: const Icon(Icons.photo_library_outlined), title: const Text('Choose from Gallery'),
            onTap: () { Navigator.pop(context); onGallery(); }),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
        ]),
      ),
    );
  }
}
