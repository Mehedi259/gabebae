##################################
## Flutter + R8 Safe Rules
##################################

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

##################################
## Play Core SplitCompat Safe Rules
##################################

-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Dontwarn generated automatically (from missing_rules.txt)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

##################################
## Stripe Safe Rules
##################################

-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

##################################
## Kotlin + Reflection + Gson
##################################

-keep class kotlin.Metadata { *; }
-keepclassmembers class * {
    <fields>;
}
-dontwarn kotlinx.**
