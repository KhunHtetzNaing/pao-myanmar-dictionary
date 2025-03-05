import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("Warning: key.properties file not found. Ensure it exists for signing configurations.")
}

android {
    signingConfigs {
        if (keystoreProperties.isNotEmpty()) {
            create("production") {
                keyAlias = keystoreProperties["keyAlias"]?.toString() ?: ""
                keyPassword = keystoreProperties["keyPassword"]?.toString() ?: ""
                storeFile = file(keystoreProperties["storeFile"]?.toString() ?: "")
                storePassword = keystoreProperties["storePassword"]?.toString() ?: ""
            }
        }
    }


    namespace = "com.htetznaing.pao_myanmar_dictionary"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.htetznaing.dic"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.findByName("production") ?: signingConfigs.getByName("debug")
        }

        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.findByName("production") ?: signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
