# Pasar Petani Project: Restoration and Setup Report

This document details the steps taken to restore the **Pasar Petani** Flutter project, resolve environment issues, configure the Android emulator, and implement a mock backend for testing purposes.

## 1. Environment & Emulator Configuration

### Initial State

The project was unable to run due to missing Flutter SDK paths and an unstable Android Emulator environment.

### Emulator Resolution (`Pixel_5`)

The `Pixel_5` emulator initially crashed immediately upon startup. The following steps stabilized the emulator:

1. **Launch Flags:** The emulator required specific flags to run on the host system:

    ```bash
    emulator -avd Pixel_5 -writable-system -no-snapshot-load
    ```

2. **Native Library Support:** To support the emulator's architecture, we explicitly added `x86` support in `android/app/build.gradle.kts`:

    ```kotlin
    ndk {
        abiFilters.add("x86")
        abiFilters.add("armeabi-v7a")
        abiFilters.add("arm64-v8a")
    }
    ```

3. **Rendering Engine:** The Impeller rendering engine caused crashes. We disabled it in `AndroidManifest.xml`:

    ```xml
    <meta-data
        android:name="io.flutter.embedding.android.EnableImpeller"
        android:value="false" />
    ```

## 2. Project Migration & Build Configuration

The project used outdated Gradle and Kotlin versions that were incompatible with the current Flutter Stable SDK (via FVM).

### Upgrades Performed

- **Flutter SDK:** Configured to use **Flutter Stable** via `fvm`.
- **Gradle:** Upgraded to **v8.13** (via `gradle-wrapper.properties`).
- **Android Gradle Plugin (AGP):** Upgraded to **v8.2.1**.
- **Kotlin:** Upgraded to **v1.9.22**.
- **Java Compatibility:** Updated build targets to **Java 17**.
- **Build Scripts:** Migrated Groovy build files (`build.gradle`) to Kotlin DSL (`build.gradle.kts`) using `flutter create .`.

### Dependency Updates

Ran `flutter pub upgrade --major-versions` to resolve constraints. Key updates included:

- `flutter_svg`: Updated to v2.x (required code changes for `flutter_svg` usage).
- `get`: Updated to v4.x.
- `http`: Updated to v1.x.

## 3. Runtime Stability Findings

During testing, we discovered a critical difference between Debug and Release builds on the emulator:

- **Debug Build:** Crashed repeatedly with `SIGSEGV` errors in `libndk_translation`. This is often due to JIT (Just-In-Time) compilation conflicts with the emulator's binary translation on x86 architectures.
- **Release Build:** Runs stable. Release builds use AOT (Ahead-Of-Time) compilation, bypassing the JIT issues.

**Recommendation:** Always test using the Release build on this specific emulator configuration.

## 4. Mock Backend Implementation

Since the original backend is unavailable, we modified the source code to allow full feature access via a "Test User".

### Modifications

1. **Authentication Service (`lib/app/services/authentication.dart`)**
    - Intercepts login requests.
    - Returns a mock User Profile with the role **'koperasi'**.
    - Mocked `getProfile()` to maintain the session.

2. **Data Service (`lib/app/services/permintaan.dart`)**
    - Intercepts `getAll()` requests.
    - Returns a hardcoded list of `Barang` (Items) with various statuses ('baru', 'diproses', 'diterima') to populate the UI tabs.

### Test Credentials

To access the app features, use:

- **Email:** `test@example.com`
- **Password:** `password`

## 5. How to Run

To build and install the working version of the app on the running emulator:

```bash
# 1. Build the Release APK (Bypasses JIT crashes)
fvm flutter build apk --release

# 2. Install onto the emulator
adb install -r build/app/outputs/flutter-apk/app-release.apk

# 3. Launch the App
adb shell am start -n com.abdulazisalayubbi.pasar_petani/com.abdulazisalayubbi.pasar_petani.MainActivity
```
