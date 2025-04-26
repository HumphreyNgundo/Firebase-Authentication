# Flutter Firebase Authentication Demo

## Project Description

This Flutter application demonstrates a complete implementation of Firebase Authentication, showcasing various user authentication methods in a clean, modern UI. The app serves as both a practical example for developers learning Firebase integration and a template for production-ready authentication flows.

## Key Features

1. **Multiple Authentication Methods:**
   - Email & Password sign-in
   - Google Sign-In
   - Apple Sign-In (iOS)
   - Phone number authentication (OTP)
   - Anonymous guest mode

2. **Core Authentication Flows:**
   - User registration with email verification
   - Password reset functionality
   - Profile management (update email, password, etc.)
   - Account linking (merge auth providers)

3. **UI Components:**
   - Customizable login/signup screens
   - Loading states and error handling
   - Success/confirmation dialogs
   - Responsive design for all screen sizes

4. **Security Features:**
   - Form validation
   - Secure credential storage
   - Session management
   - Logout functionality

5. **Additional Functionality:**
   - Dark/light theme support with Material 3
   - Analytics integration
   - Provider pattern for state management

## Getting Started

Follow these steps to set up and run the project on your local machine:

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Firebase account](https://firebase.google.com/)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extensions
- Android emulator or physical device, or iOS simulator (Mac only)
- [Git](https://git-scm.com/downloads)

### Step 1: Clone the repository

```bash
git clone https://github.com/yourusername/flutter-firebase-auth-demo.git
cd flutter-firebase-auth-demo
```

### Step 2: Install dependencies

```bash
flutter pub get
```

### Step 3: Set up Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use an existing one)
3. Add an Android app:
   - Register app with your package name (e.g., `com.example.firebaseAuth`)
   - Download `google-services.json` and place it in the `android/app/` directory
4. Add an iOS app (if developing for iOS):
   - Register app with your bundle ID (e.g., `com.example.firebaseAuth`)
   - Download `GoogleService-Info.plist` and place it in the `ios/Runner/` directory
5. Enable Authentication methods in Firebase console:
   - Go to Authentication → Sign-in method
   - Enable Email/Password, Google, Phone, Apple, and Anonymous providers
   - Configure providers with necessary API keys and settings

### Step 4: Configure Firebase CLI (optional but recommended)

```bash
# Install Firebase CLI if you haven't already
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project directory
firebase init
```

### Step 5: Update Firebase configuration

Create a file called `firebase_options.dart` in your `lib/` directory with your Firebase configuration. You can generate this file using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/).

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure your app
flutterfire configure --project=your-firebase-project-id
```

### Step 6: Configure Google Sign-In

1. For Android:
   - In the Firebase Console, go to Project settings → Your apps → SHA certificate fingerprints
   - Add your debug SHA-1 and SHA-256 fingerprints
   - Get your debug key with:
     ```bash
     cd android && ./gradlew signingReport
     ```

2. For iOS:
   - Update your `Info.plist` with required Google Sign-In configurations

### Step 7: Configure Apple Sign-In (iOS only)

1. Register for an Apple Developer account
2. Configure Sign in with Apple capability in Xcode
3. Update your Firebase project with Apple Sign-In settings

### Step 8: Run the app

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── firebase_options.dart     # Firebase configuration
├── providers/                # State management
│   ├── AuthProviders.dart    # Authentication state
│   └── ThemeProvider.dart    # Theme state
├── screens/                  # UI screens
│   ├── HomeScreen.dart       # Main authenticated screen
│   ├── ProfileScreen.dart    # User profile screen
│   ├── auth/                 # Authentication screens
│       ├── LoginScreen.dart
│       ├── RegisterScreen.dart
│       ├── ForgotPasswordScreen.dart
│       ├── PhoneAuthScreen.dart
│       ├── ChangePasswordScreen.dart
│       └── LinkAccountScreen.dart
└── services/                 # Business logic
    ├── AuthService.dart      # Firebase auth methods
    └── AnalyticsService.dart # Firebase analytics
```

## Customization

### Themes

The app includes a dark and light theme based on Material 3. To modify the theme:

1. Open `lib/providers/ThemeProvider.dart`
2. Update the `themeData` getter with your custom colors and styles

### Firebase Project Settings

To change Firebase project settings:

1. Update your `firebase_options.dart` file
2. Update the initialization in `main.dart` if necessary

## Troubleshooting

### Common Issues

1. **Firebase Authentication Failed**: Make sure you've enabled the authentication methods in Firebase Console.

2. **Google Sign-In Not Working**: Verify your SHA-1 fingerprint is correctly added to the Firebase project.

3. **Build Errors**: Make sure `google-services.json` and `GoogleService-Info.plist` are correctly placed in their respective directories.

4. **Dependencies Conflict**: Run `flutter clean` and then `flutter pub get` to refresh dependencies.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.