plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.rajemployment.eems.rajemployment"
    compileSdk = 36
    buildToolsVersion = "36.1.0"
    ndkVersion = "29.0.14206865"

    defaultConfig {
        applicationId = "com.rajemployment.eems.rajemployment"
        minSdk = 26 // ✅ Required for 16 KB page size support
        targetSdk = 36
        versionCode = 7
        versionName = "1.0.7"
        ndk {
            //   -DANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON"
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a","x86_64"))
            debugSymbolLevel = "FULL"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }

    packaging {
        jniLibs {
            useLegacyPackaging = false
        }
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
    }
    bundle {
        abi {
            enableSplit = false // Keep all architectures together for testing
        }
    }
}

flutter {
    source = "../.."
}
