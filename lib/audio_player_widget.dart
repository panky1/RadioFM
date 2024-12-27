import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 50; // Default volume

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle events
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop observing lifecycle events
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Handle background state
      FlutterBackgroundService().invoke('setAsBackground');
    } else if (state == AppLifecycleState.resumed) {
      // Handle when the app comes back to foreground
      FlutterBackgroundService().invoke('setAsForeground');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
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
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
                      } else {
                        _audioPlayer.play();
                        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Playing'});
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
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isPlaying) {
      // Ensure the audio continues playing in the background
      FlutterBackgroundService().invoke('setAsForeground');
      setState(() {
        _isPlaying = true; // Audio continues playing
      });
    }

    // Transition to the background service
    FlutterBackgroundService().invoke('setAsBackground');

    // Exit the app gracefully
    SystemNavigator.pop(); // Exits the app

    return false; // Prevents default back button behavior
  }


/*  Future<bool?> _showExitConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to stop playback and exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay in the app
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
            //  _audioPlayer.stop(); // Stop audio playback on exit
              FlutterBackgroundService().invoke('setAsBackground');
              Navigator.of(context).pop(true); // Exit the app
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }*/
}
