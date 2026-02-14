import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SubstitutionScreen extends StatelessWidget {
  const SubstitutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flavor Substitutions', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Enter missing ingredient (e.g. Eggs)',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Results Mockup
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Best Matches for "Eggs"',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView(
                children: [
                  _buildSubItem('Mashed Banana', '85% Flavor Match', 'Best for Baking', Colors.yellow),
                  _buildSubItem('Applesauce', '80% Texture Match', 'Best for Moisture', Colors.redAccent),
                  _buildSubItem('Chia Seeds', '75% Binding Match', 'High Fiber', Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(String name, String match, String tag, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
         ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(Icons.science, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(match, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Chip(
            label: Text(tag, style: const TextStyle(fontSize: 10)),
            backgroundColor: Colors.grey[100],
          ),
        ],
      ),
    );
  }
}
