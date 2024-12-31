

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:radio1/state_events/AudioPlayerEvent.dart';
import 'package:radio1/state_events/AudioPlayerState.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  double _volume = 50;

  AudioPlayerBloc(this._audioPlayer) : super(AudioPlayerInitial());

  @override
  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    if (event is PlayAudio) {
      _audioPlayer.play();
      _isPlaying = true;
      yield AudioPlayerPlaying();
      FlutterBackgroundService().invoke('togglePlayback', {'state': 'Playing'});
    } else if (event is PauseAudio) {
      _audioPlayer.pause();
      _isPlaying = false;
      yield AudioPlayerPaused();
      FlutterBackgroundService().invoke('togglePlayback', {'state': 'Paused'});
    } else if (event is VolumeChanged) {
      _volume = event.volume;
      _audioPlayer.setVolume(_volume / 100);
      yield AudioPlayerVolumeChanged(_volume);
    }
  }
}
