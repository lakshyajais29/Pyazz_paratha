import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/mood_model.dart';
import '../../recipe_suggest/screens/recipe_list_screen.dart';

class MoodSelectorScreen extends StatefulWidget {
  const MoodSelectorScreen({super.key});

  @override
  State<MoodSelectorScreen> createState() => _MoodSelectorScreenState();
}

class _MoodSelectorScreenState extends State<MoodSelectorScreen> {
  Mood? _selectedMood;

  @override
  Widget build(BuildContext context) {
    final moods = Mood.allMoods;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'How are you\nfeeling?',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'ll suggest recipes to match your mood',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),

            // Mood Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) {
                  final mood = moods[index];
                  final isSelected = _selectedMood?.name == mood.name;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedMood = mood);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? mood.color : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected ? mood.color : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? mood.color.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mood.emoji, style: const TextStyle(fontSize: 36)),
                          const SizedBox(height: 10),
                          Text(
                            mood.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mood.description,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Continue Button
            if (_selectedMood != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeListScreen(
                            moodFilter: _selectedMood!.recipeCategory,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Find ${_selectedMood!.name} Recipes',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
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
