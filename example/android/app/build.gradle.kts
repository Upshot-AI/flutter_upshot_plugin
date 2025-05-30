plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.upshot.flutter_upshot_plugin_example"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.upshot.flutter_upshot_plugin_example"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Other dependencies that might already be there, often like this:
    // implementation(project(":flutter_plugin_android_lifecycle"))
    // implementation(flutter.embedding.engine)
    // ...

    // Corrected dependencies from your list:
    implementation(platform("com.google.firebase:firebase-bom:29.2.1"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.squareup.duktape:duktape-android:1.1.0")
    implementation("androidx.work:work-runtime:2.8.1")
    implementation("androidx.core:core:1.8.0")
    implementation("com.clevertap.android:clevertap-android-sdk:4.4.0")
    implementation("com.google.firebase:firebase-messaging:21.0.0")
    implementation("androidx.core:core:1.3.0")
    implementation("androidx.fragment:fragment:1.3.6")
    implementation("androidx.appcompat:appcompat:1.3.1")
    implementation("androidx.recyclerview:recyclerview:1.2.1")
    implementation("androidx.viewpager:viewpager:1.0.0")
    implementation("com.google.android.material:material:1.4.0")
    implementation("com.github.bumptech.glide:glide:4.12.0")
    implementation("com.android.installreferrer:installreferrer:2.2")
    implementation("com.google.android.exoplayer:exoplayer:2.19.0")
    implementation("com.google.android.exoplayer:exoplayer-hls:2.19.0")
    implementation("com.google.android.exoplayer:exoplayer-ui:2.19.0")

    // The ones you added previously, now in Kotlin DSL syntax:
    implementation("com.google.android.gms:play-services-location:21.0.1")
    implementation(platform("com.google.firebase:firebase-bom:32.8.0")) // Use the latest BOM!
    implementation("com.google.firebase:firebase-messaging") // Use the latest from BOM
}

flutter {
    source = "../.."
}
