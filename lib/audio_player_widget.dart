import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';

import 'logger/AppLogger.dart';

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
  late final AppLogger logger;


  @override
  void initState() {
    super.initState();
    // Initialize AppLogger instance
    logger = AppLogger();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle events
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
    logger.debug("initState with audio player");
   /* setState(() {
      _isPlaying = true;
    });*/
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies called: Dependencies have changed.');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /* logger.debug("didChangeAppLifecycleState: $state");
    print("didChangeAppLifecycleState: $state");*/
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Handle background state
      FlutterBackgroundService().invoke('setAsBackground');
    } else if (state == AppLifecycleState.resumed) {
      // Handle when the app comes back to foreground
      FlutterBackgroundService().invoke('setAsForeground');
      // Sync UI state with background service
      if(state == 'Playing'){
        setState(() {
          logger.debug("didChangeAppLifecycleState:SetState $_isPlaying");
          print("didChangeAppLifecycleState SetState: $_isPlaying");
          _isPlaying = true; // Ensure the UI reflects the correct state
        });
      }

    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> _initAudioPlayer() async {
    try {
      // Do not reset the URL when the app resumes if it's already set in the background service.
      if (!_isPlaying) {
        await _audioPlayer.setUrl(widget.url);
        _audioPlayer.setVolume(_volume / 100);
      }
    } catch (e) {
      print('Error initializing audio player: $e');
    }
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
                      logger.debug("FloatingActionButton: setState: $_isPlaying");
                      print("FloatingActionButton setState:  $_isPlaying");
                      if (_isPlaying) {
                        logger.debug("FloatingActionButton: setState if pause: $_isPlaying");
                        print("FloatingActionButton setState if pause:  $_isPlaying");
                        _audioPlayer.pause();
                        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
                      } else {
                        logger.debug("FloatingActionButton: setState else play: $_isPlaying");
                        print("FloatingActionButton setState else play:  $_isPlaying");
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

  @override
  void deactivate() {
    logger.debug("deactivate");
    print("deactivate");
    super.deactivate();
    print('deactivate called: Widget is being removed from the tree.');
  }
  @override
  void dispose() {
    logger.debug("dispose");
    print("dispose");
    WidgetsBinding.instance.removeObserver(this); // Stop observing lifecycle events
    _audioPlayer.dispose(); // Ensure proper cleanup of the audio player
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_isPlaying) {
      logger.debug("_onWillPop: $_isPlaying");
      print("_onWillPop : $_isPlaying");
      // Ensure the audio continues playing in the background
      FlutterBackgroundService().invoke('setAsForeground');
      setState(() {
        _isPlaying = true; // Audio continues playing
        logger.debug("_onWillPop setState: $_isPlaying");
        print("_onWillPop setState: $_isPlaying");

        });
    }

    // Transition to the background service
    FlutterBackgroundService().invoke('setAsBackground');

    // Exit the app gracefully
    SystemNavigator.pop(); // Exits the app

    return false; // Prevents default back button behavior
  }
}

