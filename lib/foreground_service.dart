import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:radio1/audioplayermanager.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  final audioPlayer = AudioPlayerManager.getAudioPlayerInstance(); // Ensure proper singleton management for AudioPlayer

  if (service is AndroidServiceInstance) {
    // Handle foreground service
    service.on('setAsForeground').listen((event) {
      audioPlayer.play(); // Start audio playback
      service.setAsForegroundService(); // Set as foreground service
      service.setForegroundNotificationInfo(
        title: "HINGOLI FM",
        content: "89.6 MHz - Playing",
      );
    });

    // Handle background service
    service.on('setAsBackground').listen((event) {
      audioPlayer.pause(); // Pause audio playback
      service.setForegroundNotificationInfo(
        title: "HINGOLI FM",
        content: "89.6 MHz - Paused",
      );
    });

    // Handle stopping the service
    service.on('stopService').listen((event) {
      audioPlayer.stop(); // Stop audio playback
      service.stopSelf(); // Stop the service
    });

    // Periodic task to update the notification
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: "HINGOLI FM",
            content: "89.6 MHz - Playing",
          );
        }
      }
      print("Background service is running");
      service.invoke('update'); // Perform additional tasks here
    });

    // Handle notification updates
    service.on('updateNotification').listen((event) {
      final isPlaying = event?['isPlaying'] ?? false;
      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "HINGOLI FM",
          content: "89.6 MHz - ${isPlaying ? 'Playing' : 'Paused'}",
        );
      }
    });
  }
}