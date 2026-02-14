import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'health_condition_screen.dart';
import '../../onboarding/controller/onboarding_controller.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final OnboardingController _controller = OnboardingController();
  final TextEditingController _nameController = TextEditingController();
  
  // Local state for UI updates
  int _selectedAge = 24;
  double _weight = 70.0;
  double _height = 175.0;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    // Initialize from controller
    _nameController.text = _controller.name;
    _selectedAge = _controller.age;
    _weight = _controller.weight;
    _height = _controller.height;
    _selectedGender = _controller.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                _buildStep(true), // Ingredients (Active)
                _buildLine(),
                _buildStep(false), // Tools
                _buildLine(),
                _buildStep(false), // Serving
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Help us calibrate your kitchen metrics',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 30),

              // Name Input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Your Name',
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Gender Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   _buildGenderCard('Male', Icons.male),
                   const SizedBox(width: 20),
                   _buildGenderCard('Female', Icons.female),
                ],
              ),
              
              const SizedBox(height: 30),

              // Age Selector
              const Text(
                'YOUR AGE',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 100,
                  controller: ScrollController(initialScrollOffset: (_selectedAge - 2) * 60.0),
                  itemBuilder: (context, index) {
                    final age = index + 1;
                    final isSelected = age == _selectedAge;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAge = age;
                        });
                      },
                      child: Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          '$age',
                          style: TextStyle(
                            fontSize: isSelected ? 32 : 20,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? AppColors.textPrimary : Colors.grey[400],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 40),

              // Weight Section
              _buildMeasurementCard(
                title: 'WEIGHT',
                value: _weight,
                unit: 'KG',
                min: 30,
                max: 150,
                onChanged: (val) => setState(() => _weight = val),
              ),
              
              const SizedBox(height: 24),

              // Height Section
              _buildMeasurementCard(
                title: 'HEIGHT',
                value: _height,
                unit: 'CM',
                min: 100,
                max: 250,
                onChanged: (val) => setState(() => _height = val),
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () {
                  // Save data to controller
                  _controller.updateName(_nameController.text.trim());
                  _controller.updateAge(_selectedAge);
                  _controller.updateWeight(_weight);
                  _controller.updateHeight(_height);
                  _controller.updateGender(_selectedGender);

                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthConditionScreen(),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue to Prep'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String gender, IconData icon) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(bool isActive) {
     return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: isActive
        ? const Icon(Icons.local_fire_department, size: 14, color: Colors.white)
        : null,
    );
  }

  Widget _buildLine() {
    return Container(
      width: 20,
      height: 2,
      color: Colors.grey[300],
    );
  }

  Widget _buildMeasurementCard({
    required String title,
    required double value,
    required String unit,
    required double min,
    required double max,
    required Function(double) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: Colors.grey[100],
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(min.toInt().toString(), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                Text(max.toInt().toString(), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
