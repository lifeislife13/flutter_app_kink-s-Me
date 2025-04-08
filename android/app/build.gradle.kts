plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin") // Doit rester après kotlin
    id("com.google.gms.google-services") // Firebase
}

android {
    namespace = "com.example.kinksme"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.kinksme"get
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug") // ou release si tu en as un
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM (version unique pour tous les SDK Firebase)
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))

    // ✅ Firebase SDKs (pas besoin de version ici)
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-messaging-ktx")
    implementation("com.google.firebase:firebase-storage-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.google.firebase:firebase-appcheck-playintegrity")
    implementation("com.google.firebase:firebase-appcheck-debug")

    // 🔧 Desugar pour Java 8+ APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}