import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/recipe_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class CookingScreen extends StatefulWidget {
  final Recipe recipe;
  const CookingScreen({super.key, required this.recipe});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}



class _CookingScreenState extends State<CookingScreen> {
  int _currentStep = 0;
  
  // Timer related variables
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;
  int _stepDurationSeconds = 0; // Total duration for current step

  late PageController _pageController;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    // Speak first step after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _speakCurrentStep();
    });
  }

  Future<void> _speakCurrentStep() async {
    if (widget.recipe.instructions.isNotEmpty) {
      await _flutterTts.stop();
      await _flutterTts.speak(widget.recipe.instructions[_currentStep]);
    }
  }

  void _nextStep() {
    if (_currentStep < widget.recipe.instructions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }
  }

  void _checkForTimer(int index) {
      // Cancel existing timer when changing steps
      _stopTimer();
      
      final instruction = widget.recipe.instructions[index];
      final duration = _parseDuration(instruction);
      
      setState(() {
        _stepDurationSeconds = duration;
        _secondsRemaining = duration;
      });
  }

  int _parseDuration(String text) {
    // Regex to find "X minutes" or "X mins" or "X min"
    final regex = RegExp(r'(\d+)\s*(?:min|minute)');
    final match = regex.firstMatch(text.toLowerCase());
    if (match != null) {
      return int.parse(match.group(1)!) * 60;
    }
    return 0;
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    if (_secondsRemaining > 0) {
      setState(() => _isTimerRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _stopTimer();
          _flutterTts.speak("Time's up!");
        }
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isTimerRunning = false);
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer on dispose
    _flutterTts.stop();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cooking Assistant', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
             icon: const Icon(Icons.volume_up, color: AppColors.primary),
             onPressed: _speakCurrentStep,
           ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearPercentIndicator(
            lineHeight: 8.0,
            percent: (_currentStep + 1) / widget.recipe.instructions.length,
            backgroundColor: Colors.grey[200],
            progressColor: AppColors.primary,
          ),
          
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.recipe.instructions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
                _checkForTimer(index); // Check for timer on step change
                _speakCurrentStep();
              },
              itemBuilder: (context, index) {
                return SingleChildScrollView( // Fix RenderFlex overflow
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.6, // Ensure generated scroll view takes up space
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Container(
                           height: 200,
                           width: 200,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             shape: BoxShape.circle,
                             boxShadow: [
                               BoxShadow(
                                 color: AppColors.primary.withOpacity(0.1),
                                 blurRadius: 20,
                                 offset: const Offset(0, 10),
                               ),
                             ],
                           ),
                           child: Center(
                             child: Text(
                               'Step ${index + 1}',
                               style: const TextStyle(
                                 fontSize: 40,
                                 fontWeight: FontWeight.bold,
                                 color: AppColors.primary,
                               ),
                             ),
                           ),
                         ),
                         const SizedBox(height: 40),
                         Text(
                           widget.recipe.instructions[index],
                           textAlign: TextAlign.center,
                           style: const TextStyle(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'DM Serif Display',
                             height: 1.3,
                           ),
                         ),
                         const SizedBox(height: 40),
                         
                         // Functional Timer
                         if (_stepDurationSeconds > 0) 
                           GestureDetector(
                             onTap: _toggleTimer,
                             child: Container(
                               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                               decoration: BoxDecoration(
                                 color: _isTimerRunning ? Colors.redAccent : AppColors.primary,
                                 borderRadius: BorderRadius.circular(30),
                                 boxShadow: [
                                   BoxShadow(
                                     color: (_isTimerRunning ? Colors.redAccent : AppColors.primary).withOpacity(0.3),
                                     blurRadius: 8,
                                     offset: const Offset(0, 4),
                                   )
                                 ]
                               ),
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Icon(_isTimerRunning ? Icons.pause : Icons.timer, color: Colors.white),
                                   const SizedBox(width: 8),
                                   Text(
                                     _isTimerRunning 
                                         ? 'Pause (${_formatTime(_secondsRemaining)})' 
                                         : _secondsRemaining != _stepDurationSeconds
                                            ? 'Resume (${_formatTime(_secondsRemaining)})'
                                            : 'Start Timer (${_stepDurationSeconds ~/ 60} min)',
                                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           
                           // Add extra padding at bottom specifically for scrolling
                           const SizedBox(height: 50),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Controls
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 32),
                  color: _currentStep > 0 ? AppColors.primary : Colors.grey[300],
                  onPressed: _currentStep > 0 ? _previousStep : null,
                ),
                FloatingActionButton(
                  backgroundColor: AppColors.primary,
                  onPressed: _speakCurrentStep,
                  child: const Icon(Icons.mic), 
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 32),
                  color: _currentStep < widget.recipe.instructions.length - 1 ? AppColors.primary : Colors.grey[300],
                  onPressed: _currentStep < widget.recipe.instructions.length - 1 ? _nextStep : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
