import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recording_state.dart';
import '../services/audio_service.dart';
import '../utils/constants.dart';
import 'recording_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService audioService = AudioService();
  String? currentlyPlaying;

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Consumer<RecordingState>(
        builder: (context, state, child) {
          final recordings = state.recordings;

          if (recordings.isEmpty) {
            return Center(
              child: Text(
                'No recordings',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final filePath = recordings[index];
              final isPlaying = currentlyPlaying == filePath;

              return ListTile(
                title: Text('Recording ${index + 1}'),
                trailing: IconButton(
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  onPressed: () async {
                    if (isPlaying) {
                      await audioService.stopPlayback();
                      setState(() {
                        currentlyPlaying = null;
                      });
                    } else {
                      await audioService.stopPlayback(); // Stop any previous playback
                      await audioService.playRecording(filePath);
                      setState(() {
                        currentlyPlaying = filePath;
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RecordingPage()),
          );
        },
        child: Icon(Icons.mic),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }
}
