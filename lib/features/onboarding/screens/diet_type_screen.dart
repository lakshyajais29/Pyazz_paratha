import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'kitchen_setup_screen.dart'; 
import '../../onboarding/controller/onboarding_controller.dart';

class DietTypeScreen extends StatefulWidget {
  const DietTypeScreen({super.key});

  @override
  State<DietTypeScreen> createState() => _DietTypeScreenState();
}

class _DietTypeScreenState extends State<DietTypeScreen> {
  final OnboardingController _controller = OnboardingController();
  late String _dietType; // Derived from controller for now, though controller uses string and UI uses bools

  bool _isVegetarian = true; 
  bool _eatEggs = true;
  bool _eatFish = false;
  bool _jainFood = false;

  @override
  void initState() {
    super.initState();
    // Simple mapping for now
    _dietType = _controller.dietType;
    if (_dietType == 'Non-Vegetarian') {
      _isVegetarian = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
         title: Text(
          'STEP 4 OF 4', 
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10, 
            letterSpacing: 2,
            fontWeight: FontWeight.bold
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // Step Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'RECIPE TIMELINE COMPLETION', 
                      style: TextStyle(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 10,
                        letterSpacing: 1.5
                      )
                    ),
                     Text(
                      '100%', 
                      style: TextStyle(
                        color: AppColors.primary, 
                        fontWeight: FontWeight.bold, 
                        fontSize: 10,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                
                 Text(
                  'FINAL STEP: PERSONALIZING YOUR PLANS', 
                  style: TextStyle(
                    color: AppColors.primary.withOpacity(0.6), 
                    fontWeight: FontWeight.bold, 
                    fontSize: 8,
                    letterSpacing: 1.0
                  )
                ),

                const SizedBox(height: 30),

                Text(
                  'Any dietary preferences?',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                ),

                const SizedBox(height: 40),

                // Veg / Non-Veg Toggle (Custom Circles)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDietOption('Vegetarian', Icons.eco, true),
                    const SizedBox(width: 24),
                    _buildDietOption('Non-Vegetarian', Icons.restaurant, false),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                 Text(
                  'ADDITIONAL DETAILS', 
                  style: TextStyle(
                    color: Colors.grey, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 10,
                    letterSpacing: 1.5
                  )
                ),
                const SizedBox(height: 16),
                
                // Checklist
                _buildCheckItem('I eat eggs', Icons.egg_alt, _eatEggs, (val) => setState(() => _eatEggs = val!)),
                const SizedBox(height: 12),
                _buildCheckItem('I eat fish', Icons.set_meal, _eatFish, (val) => setState(() => _eatFish = val!)),
                const SizedBox(height: 12),
                _buildCheckItem('Jain food', Icons.lightbulb, _jainFood, (val) => setState(() => _jainFood = val!)), 

                const SizedBox(height: 40),

                 ElevatedButton(
                  onPressed: () {
                     _controller.dietType = _isVegetarian ? 'Vegetarian' : 'Non-Vegetarian';
                     
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KitchenSetupScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
                 const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'You can change these settings anytime in your profile.',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDietOption(String label, IconData icon, bool isVegOption) {
    final isSelected = isVegOption == _isVegetarian;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVegetarian = isVegOption;
        });
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? (isVegOption ? Colors.green[50] : Colors.orange[50]) : Colors.white,
                  border: Border.all(
                    color: isSelected ? (isVegOption ? Colors.green : Colors.orange) : Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: isSelected ? (isVegOption ? Colors.green : Colors.orange) : Colors.grey,
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.textPrimary : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String label, IconData icon, bool value, Function(bool?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white), // Shadow handles visuals
        boxShadow: [
           BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: SwitchListTile( // Using toggle for simpler UI than checkbox-custom
        title: Row(
          children: [
            Icon(icon, size: 20, color: Colors.orangeAccent),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        dense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
