import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
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
      await _audioPlayer.setUrl(widget.url);
      _audioPlayer.setVolume(_volume / 100);
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  void _togglePlayback() {
    setState(() {
      if (_isPlaying) {
        FlutterBackgroundService().invoke('togglePlayback');
      }
      _isPlaying = !_isPlaying;
     /* if (_isPlaying) {
        _audioPlayer.pause();
        FlutterBackgroundService().invoke('setAsBackground');
      } else {
        _audioPlayer.play();
        FlutterBackgroundService().invoke('setAsForeground');
      }
      _isPlaying = !_isPlaying;*/
    });
    // Update notification based on playback status
    FlutterBackgroundService().invoke('update', {'status': _isPlaying ? 'Playing' : 'Paused'});

  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("HINGOLI FM"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display image
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
                onPressed: _togglePlayback,
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
