import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../recipe_suggest/screens/recipe_list_screen.dart'; // Navigate to Recipe List

class MoodSelectorScreen extends StatelessWidget {
  const MoodSelectorScreen({super.key});

  final List<Map<String, dynamic>> _moods = const [
    {'name': 'Comfort', 'icon': Icons.soup_kitchen, 'color': Colors.orangeAccent, 'desc': 'Warm & Soulful'},
    {'name': 'Energetic', 'icon': Icons.bolt, 'color': Colors.yellow, 'desc': 'Power Up'},
    {'name': 'Light', 'icon': Icons.eco, 'color': Colors.green, 'desc': 'Fresh & Zesty'},
    {'name': 'Indulgent', 'icon': Icons.cake, 'color': Colors.pinkAccent, 'desc': 'Sweet Treat'},
    {'name': 'Relaxed', 'icon': Icons.nightlight_round, 'color': Colors.indigo, 'desc': 'Calm & Soothing'},
    {'name': 'Focused', 'icon': Icons.center_focus_strong, 'color': Colors.blue, 'desc': 'Brain Food'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('How are you feeling?', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select a mood to get personalized recipe suggestions.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: _moods.length,
                itemBuilder: (context, index) {
                  final mood = _moods[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecipeListScreen(), // Filter logic to be added
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: mood['color'].withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(mood['icon'], size: 40, color: mood['color']),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mood['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood['desc'],
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
