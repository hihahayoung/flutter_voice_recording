import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recording_state.dart';
import '../services/audio_service.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  final AudioService audioService = AudioService();
  String? recordingFilePath;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecordingState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recording'),
      ),
      body: Center(
        child: Consumer<RecordingState>(
          builder: (context, state, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.isRecording)
                  Text(state.isPaused ? 'Recording Paused' : 'Recording...'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: state.isRecording
                          ? null
                          : () async {
                              recordingFilePath = await audioService.startRecording();
                              state.startRecording();
                            },
                      child: const Text('Start'),
                    ),
                    ElevatedButton(
                      onPressed: state.isPaused
                          ? () async {
                              await audioService.resumeRecording();
                              state.resumeRecording();
                            }
                          : () async {
                              await audioService.pauseRecording();
                              state.pauseRecording();
                            },
                      child: Text(state.isPaused ? 'Resume' : 'Pause'),
                    ),
                    ElevatedButton(
                      onPressed: state.isRecording
                          ? () async {
                              await audioService.stopRecording();
                              if (recordingFilePath != null) {
                                state.stopRecording(recordingFilePath!);
                              }
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
