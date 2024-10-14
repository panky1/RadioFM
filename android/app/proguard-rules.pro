# Preserve all classes related to just_audio
-keep class com.ryanheise.just_audio.** { *; }

# Prevent ProGuard from stripping or obfuscating Flutter plugins (general rule)
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.view.** { *; }

# Preserve classes related to ExoPlayer, as just_audio depends on ExoPlayer for Android
-keep class com.google.android.exoplayer2.** { *; }
-keep interface com.google.android.exoplayer2.** { *; }
-keepclassmembers class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

# General AndroidX ProGuard rules (if your project uses AndroidX dependencies)
-keep class androidx.** { *; }
-dontwarn androidx.**

# Prevent ProGuard from obfuscating classes that might be needed for reflection
-keepattributes *Annotation*

# Prevent ProGuard from removing methods/classes related to debugging/logging
-assumenosideeffects class android.util.Log { *; }

-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Other common libraries
-dontwarn javax.annotation.**
-keepattributes *Annotation*
