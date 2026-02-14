import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../recipe_suggest/screens/recipe_list_screen.dart';
import '../../health_engine/screens/health_summary_screen.dart';
import '../../mood_composer/screens/mood_selector_screen.dart';
import '../../flavor_substitution/screens/substitution_screen.dart';
import '../../image_analysis/screens/image_scan_screen.dart';
import '../../profile/screens/profile_screen.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecipeListScreen()),
        ).then((_) => _resetIndex());
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthSummaryScreen()),
        ).then((_) => _resetIndex());
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) => _resetIndex());
        break;
      case 4: // FAB Action
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ImageScanScreen()),
        ).then((_) => _resetIndex());
        break;
    }
  }

  void _resetIndex() {
    setState(() {
      _selectedIndex = 0; // Reset to Home when returning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100), // Space for floating navbar
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning, Rahul',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DM Serif Display',
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '1,450 cal',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: ' remaining today'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Stack(
                          children: [
                            Icon(Icons.notifications_outlined, size: 28),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Calorie Ring - Tap to view Health Summary
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HealthSummaryScreen()),
                        );
                      },
                      child: Center(
                        child: CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 18.0,
                          percent: 0.65,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "1450",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Text(
                                "CAL REMAINING",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                  color: Colors.grey,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          progressColor: AppColors.ringYellow,
                          backgroundColor: Colors.grey[200]!,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(Colors.green, 'Protein'),
                        const SizedBox(width: 16),
                        _buildLegendItem(const Color(0xFFffb74d), 'Carbs'),
                        const SizedBox(width: 16),
                        _buildLegendItem(Colors.redAccent, 'Fat'),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Mood Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'How are you feeling today?',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'DM Serif Display',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MoodSelectorScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RecipeListScreen()),
                              );
                            },
                            child: _buildMoodCard(
                              'Comfort',
                              'Warm & Soulful',
                              AppColors.comfortStart,
                              AppColors.comfortEnd,
                              Icons.soup_kitchen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RecipeListScreen()),
                              );
                            },
                            child: _buildMoodCard(
                              'Light & Fresh',
                              'Zesty & Green',
                              AppColors.freshStart,
                              AppColors.freshEnd,
                              Icons.eco,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'WATER INTAKE',
                            '1.2L',
                            Icons.water_drop,
                            Colors.blue[100]!,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'STEPS TODAY',
                            '8,432',
                            Icons.directions_walk,
                            Colors.orange[100]!,
                            Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Chef Tools Section
                     Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.science, color: Colors.white, size: 32),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Flavor Lab',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                Text(
                                  'Find substitutes & pairings',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SubstitutionScreen()),
                              );
                            },
                          )
                        ],
                      ),
                     ),
                  ],
                ),
              ),
            ),
          ),
          
          // Floating Bottom Navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 3, backgroundColor: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildMoodCard(String title, String subtitle, Color startColor, Color endColor, IconData icon) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [startColor, endColor],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(icon, color: Colors.white.withOpacity(0.5), size: 32),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}
