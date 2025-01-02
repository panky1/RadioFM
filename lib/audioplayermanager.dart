

import 'package:just_audio/just_audio.dart';

class AudioPlayerManager {
  static AudioPlayer? _audioPlayerInstance;

  static AudioPlayer getAudioPlayerInstance() {
    _audioPlayerInstance ??= AudioPlayer();
    return _audioPlayerInstance!;
  }
}