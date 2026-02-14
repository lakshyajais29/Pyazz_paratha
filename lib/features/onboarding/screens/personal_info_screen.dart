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
  
  // Local state for UI updates
  int _selectedAge = 24;
  double _weight = 70.0;
  double _height = 175.0;
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    // Initialize from controller
    _selectedAge = _controller.age;
    _weight = _controller.weight;
    _height = _controller.height;
    _selectedGender = _controller.gender;
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

              // Weight & Height Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weight Section
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'WEIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Weight Display
                        Container(
                          width: 120,
                          height: 120,
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
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _weight.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'KG',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Weight Slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: Colors.grey[200],
                            thumbColor: AppColors.primary,
                            overlayColor: AppColors.primary.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _weight,
                            min: 30,
                            max: 150,
                            onChanged: (value) {
                              setState(() {
                                _weight = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Height Section
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'HEIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.white, AppColors.primary.withOpacity(0.05)],
                                ),
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
                                  Text(
                                    _height.toInt().toString(),
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'CM',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              height: 200,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primary,
                                    inactiveTrackColor: Colors.grey[200],
                                    thumbColor: AppColors.primary,
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: _height,
                                    min: 100,
                                    max: 250,
                                    onChanged: (value) {
                                      setState(() {
                                        _height = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              ElevatedButton(
                onPressed: () {
                  // Save data to controller
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
}
