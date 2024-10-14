import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MaterialApp(
    home: AudioPlayerWidget(url: 'http://103.112.32.142/hls/hingolifm/live.m3u8'),
  ));
}

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 50; // Default volume

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.url); // Set the audio stream URL
      _audioPlayer.setVolume(_volume / 100); // Set initial volume
    } catch (e) {
      print('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Clean up audio player resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image section
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/file.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Volume Slider
              Slider(
                value: _volume,
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Volume ${_volume.round()}',
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                    _audioPlayer.setVolume(_volume / 100);
                  });
                },
              ),
              Text(
                _isPlaying ? 'Playing' : 'Paused',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Play/Pause Button
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                    _isPlaying = !_isPlaying; // Toggle play state
                  });
                },
                child: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
