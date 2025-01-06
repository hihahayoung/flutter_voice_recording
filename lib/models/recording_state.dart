import 'package:flutter/material.dart';

class RecordingState extends ChangeNotifier {
  bool _isRecording = false;
  bool _isPaused = false;
  List<String> _recordings = [];

  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;
  List<String> get recordings => _recordings;

  void startRecording() {
    _isRecording = true;
    _isPaused = false;
    notifyListeners();
  }

  void pauseRecording() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeRecording() {
    _isPaused = false;
    notifyListeners();
  }

  void stopRecording(String filePath) {
    _isRecording = false;
    _isPaused = false;
    _recordings.add(filePath);
    notifyListeners();
  }

  void cancelRecording() {
    _isRecording = false;
    _isPaused = false;
    notifyListeners();
  }
}
