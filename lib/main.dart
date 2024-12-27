import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:radio1/audio_player_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check and request required permissions
  await checkAndRequestPermissions();
  // await initializeService();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home:
    AudioPlayerWidget(url: 'http://103.112.32.142:8000/stream'),
    //AudioPlayerWidget(url: 'https://streams.ilovemusic.de/iloveradio6.mp3'),
  ));
  Future.delayed(const Duration(seconds: 2), initializeService);
}

/// Check and request necessary permissions
Future<void> checkAndRequestPermissions() async {
  final permissions = [
    Permission.notification, //  notifications for Android 13+
  ];

  // Request  permission
  for (final permission in permissions) {
    if (await permission.isDenied || await permission.isPermanentlyDenied) {
      final status = await permission.request();
      if (!status.isGranted) {
        print('Permission denied: $permission');
      }
    }
  }
}

/// Initializes the background service
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

/// iOS background service entry point
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

/// Android/iOS foreground service entry point

/// Android/iOS foreground service entry point
@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  // Initialize the audio player with a default URL
  audioPlayer.setUrl('http://103.112.32.142:8000/stream');

  if (service is AndroidServiceInstance) {
    // Handle foreground service behavior
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
      service.setForegroundNotificationInfo(
          title: "HINGOLI FM",
          content: isPlaying ? "Playing" : "Paused"
      );
    });

    // Handle background service behavior
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });

    // Listen for playback toggle events
    service.on('togglePlayback').listen((event) {
      if (event?['state'] == 'Playing') {
        audioPlayer.play();
        isPlaying = true;
      } else if (event?['state'] == 'Paused') {
        audioPlayer.pause();
        isPlaying = false;
      }
      // Update the foreground notification based on playback state
      service.setForegroundNotificationInfo(
        title: "HINGOLI FM",
        content: isPlaying ? "Playing" : "Paused",
      );
    });

  }

  // Listen for stop service event
  service.on('stopService').listen((event) {
    audioPlayer.stop();
    service.stopSelf();
  });

  // Periodic timer to update the notification and perform background operations
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // Update the notification content based on playback status
        service.setForegroundNotificationInfo(
          title: "HINGOLI FM",
          content: isPlaying ? "Playing" : "Paused",
        );
      }
    }

    // Ensure the audio stream is still set (in case the URL changes)
   /* audioPlayer.setUrl('http://103.112.32.142:8000/stream');*/
    print("Background service is running");

    // Perform any other background tasks you need
    service.invoke('update');
  });
}

