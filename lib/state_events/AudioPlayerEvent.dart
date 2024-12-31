

abstract class AudioPlayerEvent {}

class PlayAudio extends AudioPlayerEvent {}

class PauseAudio extends AudioPlayerEvent {}

class VolumeChanged extends AudioPlayerEvent {
  final double volume;

  VolumeChanged(this.volume);
}