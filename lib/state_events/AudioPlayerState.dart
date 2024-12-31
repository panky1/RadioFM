
abstract class AudioPlayerState {}

class AudioPlayerInitial extends AudioPlayerState {}

class AudioPlayerPlaying extends AudioPlayerState {}

class AudioPlayerPaused extends AudioPlayerState {}

class AudioPlayerVolumeChanged extends AudioPlayerState {
  final double volume;

  AudioPlayerVolumeChanged(this.volume);
}
