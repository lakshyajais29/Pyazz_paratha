import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../onboarding/screens/health_condition_screen.dart'; // Back to onboarding check

class HealthSummaryScreen extends StatelessWidget {
  const HealthSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Health Engine', style: TextStyle(color: AppColors.textPrimary, fontFamily: 'DM Serif Display', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Head/Brain Visualization (Using icon for now)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                   const Icon(Icons.psychology, size: 120, color: AppColors.primary),
                   Positioned(
                     bottom: 20,
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                       decoration: BoxDecoration(
                         color: AppColors.background,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: const Text('Metabolic State: OPTIMAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                     ),
                   ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Grid
            Row(
              children: [
                Expanded(child: _buildStatCard('BMR', '1850', 'kcal/day', Icons.local_fire_department, Colors.orangeAccent)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('BMI', '22.4', 'Normal', Icons.accessibility, Colors.blueAccent)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard('Hydration', '1.2', 'Liters', Icons.water_drop, Colors.blue)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Sleep', '7.5', 'Hours', Icons.bedtime, Colors.purpleAccent)),
              ],
            ),

            const SizedBox(height: 30),
            
            // Adjust Plan Button
            OutlinedButton.icon(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HealthConditionScreen()),
                 );
              },
              icon: const Icon(Icons.settings),
              label: const Text('Adjust Health Profile'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'DM Serif Display')),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
