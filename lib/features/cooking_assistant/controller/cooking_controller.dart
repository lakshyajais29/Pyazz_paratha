import 'dart:async';
import '../../../core/services/voice_service.dart';

class CookingController {
  final VoiceService _voiceService = VoiceService();

  List<String> instructions = [];
  int currentStep = 0;
  bool isTimerRunning = false;
  int timerSeconds = 0;
  Timer? _timer;

  /// Initialize with recipe instructions
  void initialize(List<String> recipeInstructions) {
    instructions = recipeInstructions;
    currentStep = 0;
    stopTimer();
  }

  /// Go to next step
  bool nextStep() {
    if (currentStep < instructions.length - 1) {
      currentStep++;
      return true;
    }
    return false;
  }

  /// Go to previous step
  bool previousStep() {
    if (currentStep > 0) {
      currentStep--;
      return true;
    }
    return false;
  }

  /// Current instruction text
  String get currentInstruction {
    if (instructions.isEmpty) return 'No instructions available';
    return instructions[currentStep];
  }

  /// Progress fraction (0.0 to 1.0)
  double get progress {
    if (instructions.isEmpty) return 0;
    return (currentStep + 1) / instructions.length;
  }

  /// Is at last step?
  bool get isLastStep => currentStep >= instructions.length - 1;

  /// Is at first step?
  bool get isFirstStep => currentStep == 0;

  /// Speak current instruction
  Future<void> speakCurrentStep() async {
    await _voiceService.speak(currentInstruction);
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _voiceService.stop();
  }

  /// Start a timer (in seconds)
  void startTimer(int seconds, {Function()? onTick, Function()? onComplete}) {
    stopTimer();
    timerSeconds = seconds;
    isTimerRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        timerSeconds--;
        onTick?.call();
      } else {
        stopTimer();
        onComplete?.call();
      }
    });
  }

  /// Stop timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    isTimerRunning = false;
  }

  /// Format seconds to MM:SS
  String get timerDisplay {
    final minutes = timerSeconds ~/ 60;
    final secs = timerSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// Dispose resources
  void dispose() {
    stopTimer();
    _voiceService.stop();
  }
}
