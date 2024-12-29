
import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
 /* static AudioPlayer? _audioPlayerInstance;

  static AudioPlayer getAudioPlayerInstance() {
    _audioPlayerInstance ??= AudioPlayer();
    return _audioPlayerInstance!;
  }*/

  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  late final AudioPlayer _audioPlayer;

  // Private constructor
  AudioPlayerManager._internal() {
    _audioPlayer = AudioPlayer();
  }
  static AudioPlayer getAudioPlayerInstance() {
    return _instance._audioPlayer;
  }
  // Singleton accessor
  factory AudioPlayerManager() => _instance;

  // Getter for the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Dispose the player if needed
  void dispose() {
    _audioPlayer.dispose();
  }
}