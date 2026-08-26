# RadioFM – Flutter Internet Radio App

A Flutter-based Internet Radio application that streams live radio audio from a configured streaming URL. The project demonstrates **audio streaming, Android Foreground Service, background playback, and notification-based playback controls**.

## 🚀 Features

* 🎵 Live radio streaming using a configured streaming URL
* ▶️ Play / Pause radio stream
* ⏹️ Stop radio playback
* 🔄 Continuous audio playback
* 📱 Android Foreground Service for background playback
* 🔔 Notification-based playback controls
* 📡 Internet-based audio streaming
* ⚡ Flutter-based Android application

## 🛠️ Technologies Used

* Flutter
* Dart
* Android
* Android Foreground Service
* Audio Streaming
* Background Audio Playback
* Android Notifications

## 🎧 Radio Streaming

The application streams audio from a configured radio streaming URL.

Example:

```dart
const String radioStreamUrl = "YOUR_STREAM_URL";
```

Replace `YOUR_STREAM_URL` with the actual radio streaming URL.

An active internet connection is required for streaming.

## 🔄 Foreground Service

The application uses an **Android Foreground Service** to keep the radio stream running when the application moves into the background.

### Service Flow

```text
Flutter UI
    │
    ▼
Audio Controller
    │
    ▼
Foreground Service
    │
    ▼
Audio Stream
    │
    ▼
Radio Server
```

## 🔔 Background Playback

When the user starts the radio:

1. The audio stream starts.
2. The Android Foreground Service starts.
3. A persistent notification is displayed.
4. The user can move the application to the background.
5. Audio continues playing in the background.
6. Playback can be controlled through the notification.

## 🔐 Android Permissions

The application requires permissions for Internet access and Android Foreground Service.

```xml
<uses-permission android:name="android.permission.INTERNET" />

<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
```

## 📱 Application Flow

```text
Launch Application
       │
       ▼
Radio Screen
       │
       ▼
User taps Play
       │
       ▼
Start Audio Stream
       │
       ▼
Start Foreground Service
       │
       ▼
Display Media Notification
       │
       ▼
Audio continues in Background
       │
       ▼
Play / Pause / Stop
```

## ▶️ Getting Started

### Prerequisites

* Flutter SDK
* Dart SDK
* Android Studio
* Android SDK
* Android device or emulator
* Valid radio streaming URL

### Clone Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

### Navigate to Project

```bash
cd radiofm
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

## ⚙️ Configure Radio Stream

Configure the radio streaming URL in the appropriate project file:

```dart
const String radioStreamUrl = "https://example.com/radio-stream";
```

Then run the application.

## 🔥 Key Technical Implementation

* Implemented live Internet radio streaming.
* Implemented Android Foreground Service for continuous background playback.
* Implemented notification-based Play/Pause/Stop controls.
* Handled audio playback and service lifecycle.
* Integrated Flutter with Android platform-specific functionality.
* Configured Android Foreground Service permissions for media playback.

## 📸 Screenshots

Add application screenshots here.

```text
screenshots/
├── home.png
├── playing.png
└── notification.png
```

## ⚠️ Important

The application requires a valid and publicly accessible radio streaming URL.

Streaming availability depends on the configured radio server. If the stream is unavailable, playback may fail.

## 👨‍💻 Author

**Pankaj Prajapati**

Senior Android Developer | Flutter Developer
