import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../onboarding/controller/onboarding_controller.dart';
import '../../health_engine/controller/health_engine_controller.dart';

class HealthSummaryScreen extends StatelessWidget {
  const HealthSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController();
    final healthEngine = HealthEngineController();

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
        title: const Text(
          'Health Summary',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BMI/BMR Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'BMR',
                    '${healthEngine.bmr.toStringAsFixed(0)} kcal',
                    'Daily baseline burn',
                    Icons.local_fire_department,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'BMI',
                    healthEngine.bmi.toStringAsFixed(1),
                    healthEngine.bmiCategory,
                    Icons.monitor_weight,
                    _bmiColor(healthEngine.bmi),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Calorie Target Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    'DAILY CALORIE TARGET',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${healthEngine.dailyCalorieTarget.toStringAsFixed(0)} kcal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${controller.goal}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Macro Goals
            const Text(
              'RECOMMENDED MACROS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMacroCard(
                    'Protein',
                    '${healthEngine.recommendedMacros['protein']?.toStringAsFixed(0)}g',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMacroCard(
                    'Carbs',
                    '${healthEngine.recommendedMacros['carbs']?.toStringAsFixed(0)}g',
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMacroCard(
                    'Fat',
                    '${healthEngine.recommendedMacros['fat']?.toStringAsFixed(0)}g',
                    Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's Progress
            const Text(
              'TODAY\'S PROGRESS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProgressRow(
                    'Calories',
                    '${healthEngine.todayCalories} / ${healthEngine.dailyCalorieTarget.toStringAsFixed(0)} kcal',
                    healthEngine.dailyCalorieTarget > 0
                        ? (healthEngine.todayCalories / healthEngine.dailyCalorieTarget).clamp(0.0, 1.0)
                        : 0.0,
                    AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  _buildProgressRow(
                    'Protein',
                    '${healthEngine.todayProtein.toStringAsFixed(0)}g / ${healthEngine.recommendedMacros['protein']?.toStringAsFixed(0)}g',
                    (healthEngine.recommendedMacros['protein'] ?? 1) > 0
                        ? (healthEngine.todayProtein / (healthEngine.recommendedMacros['protein'] ?? 1)).clamp(0.0, 1.0)
                        : 0.0,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  _buildProgressRow(
                    'Meals Logged',
                    '${healthEngine.mealsLoggedToday}',
                    (healthEngine.mealsLoggedToday / 4).clamp(0.0, 1.0), // 4 meals target
                    Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Health Profile Summary
            const Text(
              'YOUR PROFILE',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow('Age', '${controller.age} years'),
                  _buildInfoRow('Weight', '${controller.weight} kg'),
                  _buildInfoRow('Height', '${controller.height} cm'),
                  _buildInfoRow('Gender', controller.gender),
                  _buildInfoRow('Goal', controller.goal),
                  _buildInfoRow('Diet', controller.dietType),
                  if (controller.healthConditions.isNotEmpty)
                    _buildInfoRow('Conditions', controller.healthConditions.join(', ')),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[100],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }
}
