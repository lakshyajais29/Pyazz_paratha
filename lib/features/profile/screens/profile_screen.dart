import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../onboarding/controller/onboarding_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // Light beige from mockup
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
          'Profile', 
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )
        ),
        centerTitle: true,
        actions: [
           Container(
             margin: const EdgeInsets.only(right: 16),
             decoration: const BoxDecoration(
               color: Colors.white,
               shape: BoxShape.circle,
             ),
             child: IconButton(
               icon: const Icon(Icons.settings, color: AppColors.textPrimary, size: 20),
               onPressed: () {},
             ),
           ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      // In real app, use Image.asset or network with ClipOval
                      // Using a simple decoration for now to match "leafy" look
                      gradient: LinearGradient(
                        colors: [Colors.green[50]!, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'R',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'DM Serif Display',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Name & Details
              const Text(
                'Rahul',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM Serif Display',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${controller.age} years old', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Container(height: 4, width: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(controller.goal.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Weekly Insights Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0), // Warmer beige
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text(
                      'WEEKLY INSIGHTS', 
                      style: TextStyle(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 10,
                        letterSpacing: 1.5
                      )
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Avg Calorie Intake', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('1,650', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                             Text(' cal/day', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: 0.85,
                      backgroundColor: Colors.white.withOpacity(0.5),
                      progressColor: AppColors.primary,
                      barRadius: const Radius.circular(4),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Goal Adherence', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        Text('85%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Health Profile Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Health Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DM Serif Display',
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
               // Health Tags
               Row(
                 children: [
                   if (controller.healthConditions.isEmpty)
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                       decoration: BoxDecoration(
                         color: const Color(0xFFFFE0B2), // Light orange
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: const Row(
                         children: [
                           Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                           SizedBox(width: 8),
                           Text('No Conditions', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                         ],
                       ),
                     )
                   else
                     ...controller.healthConditions.map((condition) => 
                       Padding(
                         padding: const EdgeInsets.only(right: 12.0),
                         child: Container(
                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                           decoration: BoxDecoration(
                             color: AppColors.primary,
                             borderRadius: BorderRadius.circular(20),
                           ),
                           child: Row(
                             children: [
                               const Icon(Icons.monitor_heart, color: Colors.white, size: 16),
                               const SizedBox(width: 8),
                               Text(condition, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                             ],
                           ),
                         ),
                       )
                     ).toList(),
                 ],
               ),
               const SizedBox(height: 12),
               // Add Condition Button
               Align(
                 alignment: Alignment.centerLeft,
                 child: Container(
                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid), // Dotted is hard in standard container, solid looks ok or custom paint
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: const Text('+ Add Condition', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                 ),
               ),

               const SizedBox(height: 30),

               // Settings List
               Container(
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
                 child: Column(
                   children: [
                     _buildSettingsItem(Icons.restaurant, 'Diet Preferences', controller.dietType),
                     _buildDivider(),
                     _buildSettingsItem(Icons.medical_services, 'Health Conditions', controller.healthConditions.join(', ')),
                     _buildDivider(),
                     _buildSettingsItem(Icons.track_changes, 'Goals', controller.goal),
                     _buildDivider(),
                     _buildSettingsItem(Icons.notifications, 'Meal Reminders', ''),
                     _buildDivider(),
                     _buildSettingsItem(Icons.mic, 'Voice Settings', ''),
                     _buildDivider(),
                     _buildSwitchItem(Icons.dark_mode, 'Dark Mode'),
                   ],
                 ),
               ),
               const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSwitchItem(IconData icon, String title) {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Slightly less padding for switch
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[50], // Match others
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Switch(
            value: false, 
            onChanged: (val) {},
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 60), // Indent divider
      height: 1,
      color: Colors.grey[100],
    );
  }
}
