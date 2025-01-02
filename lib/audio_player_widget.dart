import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_visualizer/music_visualizer.dart';

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
  final List<Color> colors = [
    Colors.red[900]!,
    Colors.green[900]!,
    Colors.blue[900]!,
    Colors.brown[900]!
  ];

  final List<int> duration = [900, 700, 600, 800, 500];

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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Send the app to the background while keeping the audio and service active
    FlutterBackgroundService().invoke('setAsBackground'); // Notify the service
    // Minimize the app
    return true; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: Scaffold(
        backgroundColor: Colors.orange,
        appBar: AppBar(
          title: const Text("HINGOLI FM"),
          backgroundColor: Colors.deepOrange,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountEmail: const Text("Sune Dil Se"),
                accountName: const Text("HINGOLI FM"),
                currentAccountPicture: const CircleAvatar(
                  foregroundImage: AssetImage('assets/images/file.jpeg'),
                ),
                decoration: const BoxDecoration(
                  color: Colors.deepOrange,
                ),
                      ),

              // Section: Features
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Features",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ),
                    ListTile(
                leading: const Icon(Icons.info, color: Colors.deepOrange),
                title: const Text("About Us"),
                onTap: () {},
                    ),
                    ListTile(
                leading: const Icon(Icons.mail, color: Colors.deepOrange),
                title: const Text("Contact"),
                onTap: () {},
                ),

              // Section: Info
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Address",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "HINGOLI FM 89.6 MHz (Suno dill se...)\nRamakrishna Nagar, Balsond, Dist.Hingoli- 431513, (Maharashtra)",
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Broadcast Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("24H"),
                    SizedBox(height: 10),
                    Text(
                      "Band Quality",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Digital"),
                    SizedBox(height: 10),
                    Text(
                      "Language",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Hindi, Marathi & English"),
                    SizedBox(height: 10),
                    Text(
                      "Coverage Area",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Whole World"),
                    SizedBox(height: 10),
                    Text(
                      "Listeners",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Unlimited"),
                    SizedBox(height: 10),
                    Text(
                      "Mail ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("hingolifm.89.6mhz@gmail.com"),
                    SizedBox(height: 10),
                    Text(
                      "Facebook",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("HINGOLI FM"),
                    SizedBox(height: 10),
                    Text(
                      "Broadcasters",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(1) Trishna Kapoor 9315826394, 8805392556\n(2) Vijay R Thakur 9422650659",
                    ),
                  ],
                ),
              ),

              // Section: Settings
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.deepOrange),
                title: const Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.deepOrange),
                title: const Text("Help"),
                onTap: () {},
              ),
            ],
          ),
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

                // Show MusicVisualizer only when audio is playing
                SizedBox(
                  height: 80,
                  child: MusicVisualizer(
                      colors: colors, duration: duration, barCount: 30),
                ),
                SizedBox(height: 10),
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
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Play/Pause Button
                FloatingActionButton(
                  // onPressed: _togglePlayback,
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        _audioPlayer.pause();
                        FlutterBackgroundService()
                            .invoke('togglePlayback', {'state': 'Paused'});
                      } else {
                        _audioPlayer.play();
                        FlutterBackgroundService()
                            .invoke('togglePlayback', {'state': 'Playing'});
                        //FlutterBackgroundService().invoke('setAsForeground');
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
}