plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Untuk Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.to_do_in"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.todo.memoire"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ Konfigurasi Google Sign-In via metadata (opsional tambahan jika perlu)
        // Tambahkan ini jika Anda menggunakan library native Google Sign-In
        // resValue("string", "default_web_client_id", "YOUR_WEB_CLIENT_ID")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // Untuk Firebase Proguard (jika perlu)
            // minifyEnabled true
            // proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Untuk mendukung fitur Java 8 (misalnya lambdas atau time API)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // ✅ Firebase & Google Sign-In (opsional jika Anda menambah dependency manual)
    // implementation 'com.google.firebase:firebase-auth' (via Flutter plugin biasanya sudah cukup)
    // implementation 'com.google.android.gms:play-services-auth:20.7.0' // Google Sign-In Android
}
