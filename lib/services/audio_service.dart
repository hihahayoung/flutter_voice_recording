import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;

  AudioService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;

      await _player.openPlayer();
      _isPlayerInitialized = true;
    } catch (e) {
      print("Error initializing Flutter Sound: $e");
    }
  }

  Future<String> startRecording() async {
    if (!_isRecorderInitialized) throw Exception("Recorder not initialized");
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: filePath);
    return filePath;
  }

  Future<void> stopRecording() async {
    if (!_isRecorderInitialized) throw Exception("Recorder not initialized");
    await _recorder.stopRecorder();
  }

  Future<void> resumeRecording() async {
    if (!_isRecorderInitialized) throw Exception("Recorder not initialized");
    await _recorder.resumeRecorder();
  }

  Future<void> pauseRecording() async {
    if (!_isRecorderInitialized) throw Exception("Recorder not initialized");
    await _recorder.pauseRecorder();
  }

  Future<void> playRecording(String filePath) async {
    if (!_isPlayerInitialized) throw Exception("Player not initialized");
    await _player.startPlayer(fromURI: filePath);
  }

  Future<void> stopPlayback() async {
    if (!_isPlayerInitialized) throw Exception("Player not initialized");
    await _player.stopPlayer();
  }

  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
  }
}
