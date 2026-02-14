import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ImageScanScreen extends StatelessWidget {
  const ImageScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera preview background
      body: Stack(
        children: [
          const Center(
            child: Icon(Icons.camera_alt, color: Colors.white54, size: 80),
          ),
          // Overlay
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 2),
            ),
            margin: const EdgeInsets.all(40),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  'Scanning ingredients...',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                     // Simulate capture
                     Navigator.pop(context);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Close button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
