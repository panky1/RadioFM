import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:radio1/applogger.dart';
import 'package:radio1/audioplayermanager.dart';
import 'package:radio1/bloc/AudioPlayerBloc.dart';
import 'package:radio1/state_events/AudioPlayerEvent.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String url;

  const AudioPlayerWidget({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioPlayer _audioPlayer = AudioPlayerManager.getAudioPlayerInstance(); // Initialize the audio player here

    return BlocProvider<AudioPlayerBloc>(
      create: (context) => AudioPlayerBloc(_audioPlayer),
      child: AudioPlayerWidgetBody(url: url),
    );
  }
}

class AudioPlayerWidgetBody extends StatefulWidget {
  final String url;

  const AudioPlayerWidgetBody({Key? key, required this.url}) : super(key: key);

  @override
  State<AudioPlayerWidgetBody> createState() => _AudioPlayerWidgetBodyState();
}

class _AudioPlayerWidgetBodyState extends State<AudioPlayerWidgetBody> with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 50; // Default volume
  bool _isInitialized = false;
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
    _audioPlayer = AudioPlayerManager.getAudioPlayerInstance();
  }

  Future<void> _initAudioPlayer() async {
    try {
      if (_audioPlayer.sequenceState == null) {
        await _audioPlayer.setUrl(widget.url);
        await _audioPlayer.stop(); // Ensure it's paused on initialization
        print('Stream URL set successfully.');
      } else {
        print('Audio player already initialized.');
      }

      _audioPlayer.setVolume(_volume / 100);

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        AppLogger().debug("playerStateStream ");
        setState(() {
          _isPlaying = state.playing;
        });
      });

    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    if (!_audioPlayer.playing) {
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState: $state");
    switch (state) {
      case AppLifecycleState.paused:
        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
        break;
      case AppLifecycleState.resumed:
        if (!_isInitialized) {
          _initAudioPlayer();
        }
        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Playing'});
        break;
      default:
        break;
    }
  }

  Future<bool> _onWillPop() async {
    FlutterBackgroundService().invoke('setAsBackground');
    return true; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
                  onPressed: () {
                    setState(() {
                      if (_audioPlayer.playing) {
                        // Dispatch pause event
                        BlocProvider.of<AudioPlayerBloc>(context).add(PauseAudio());
                      } else {
                        // Dispatch play event
                        BlocProvider.of<AudioPlayerBloc>(context).add(PlayAudio());
                      }
                    });
                  },
                  child: Icon(
                    _audioPlayer.playing ? Icons.pause_circle : Icons.play_circle,
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

/*
class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 50; // Default volume
  bool _isInitialized = false;
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
    _audioPlayer = AudioPlayerManager.getAudioPlayerInstance();

   */
/* WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayerManager.getAudioPlayerInstance();
    _initAudioPlayer();*//*

  }


  Future<void> _initAudioPlayer() async {
    try {
      // Guard against re-initialization
      if (_audioPlayer.sequenceState == null) {
        await _audioPlayer.setUrl(widget.url);
        await _audioPlayer.stop(); // Ensure it's paused on initialization
        print('Stream URL set successfully.');
      } else {
        print('Audio player already initialized.');
      }

      _audioPlayer.setVolume(_volume / 100);

      // Listen to player state changes
      _audioPlayer.playerStateStream.listen((state) {
        AppLogger().debug("playerStateStream ");
        setState(() {
          _isPlaying = state.playing;
        });
      });

    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Only dispose if needed, as the singleton manages the player lifecycle
    if (!_audioPlayer.playing) {
      _audioPlayer.dispose();
    }
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState: $state");
    print("AppLifecycleState: $state");
    switch (state) {
      case AppLifecycleState.paused:
      // App moved to the background, you can handle background audio here
        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
        break;
      case AppLifecycleState.resumed:
        print("App is resumed");
      // App returned to the foreground, resume the playback
        if (!_isInitialized) {
          _initAudioPlayer();
        }
        FlutterBackgroundService().invoke('togglePlayback', {'state': 'Playing'});
        break;
      case AppLifecycleState.detached:
        print("App is being terminated");
        break;
      default:
        break;
    }
  */
/*  if (state == AppLifecycleState.detached) {
      // App is being terminated
      print("App is being terminated");
    }*//*

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
      onWillPop: _onWillPop,
      // Intercept back button press
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
              onPressed: ()  {
                setState(() {
                  if (_audioPlayer.playing ) {
                   // _audioPlayer.pause();
                    BlocProvider.of<AudioPlayerBloc>(context).add(PauseAudio());
                    FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
                  } else {
                    BlocProvider.of<AudioPlayerBloc>(context).add(PlayAudio());
                  //  _audioPlayer.play();
                    FlutterBackgroundService().invoke('togglePlayback', {'state': 'Playing'});
                  }
                  // UI reflects the actual playback state
                //  _isPlaying = !_isPlaying;

                });
              },
              child: Icon(
               // _isPlaying ? Icons.pause_circle : Icons.play_circle,
                _audioPlayer.playing ? Icons.pause_circle : Icons.play_circle,
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
*/




