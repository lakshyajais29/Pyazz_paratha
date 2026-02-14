// Voice Service - TTS for cooking assistant
// Using flutter_tts is optional; for hackathon, this provides the interface
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// Speak the given text aloud (TTS)
  /// For hackathon demo, this is a placeholder that can be connected to flutter_tts
  Future<void> speak(String text) async {
    _isSpeaking = true;
    // In production: await flutterTts.speak(text);
    // For now, simulate a short delay
    await Future.delayed(const Duration(seconds: 2));
    _isSpeaking = false;
  }

  /// Stop speaking
  Future<void> stop() async {
    _isSpeaking = false;
    // In production: await flutterTts.stop();
  }
}
