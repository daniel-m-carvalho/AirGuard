# Setting Up and Running AirGuard WebApp

This guide provides step-by-step instructions to configure and run the `AirGuard WebApp` project. Follow each step carefully to ensure proper setup.

---

## Prerequisites

1. **Operating System:**

   - Compatible with **Windows**, **macOS**, or **Linux**.

2. **Required Tools and Software:**
   - [**Flutter SDK**](https://flutter.dev/docs/get-started/install) (includes Dart).
   - A code editor like [**VS Code**](https://code.visualstudio.com/) or [**Android Studio**](https://developer.android.com/studio).
   - [**Firebase CLI**](https://firebase.google.com/docs/cli).
   - [**Node.js**](https://nodejs.org/) (required for Firebase CLI).

---

## Project Setup

### Option 1: Cloning the Repository

1. Clone the project repository:

   ```bash
   git clone https://github.com/your-repo/air_guard_webapp.git

   ```

2. **Navigate to the project directory:**
   ```bash
   cd myweb_app
   ```

### Option 2: Downloading the Project as a ZIP

1. **Download the project:**

   - Go to the repository page.
   - Click on **Code > Download ZIP**.

2. **Extract the ZIP file:**

   - Extract the contents to your desired directory.

3. **Navigate to the extracted folder:**
   ```bash
   cd path/to/extracted/myweb_app
   ```

---

## Enabling Developer Mode

Before proceeding with Firebase and Flutter configuration, it's recommended to enable developer mode to avoid potential issues with packages and permissions. Here's how to enable developer mode:

#### Windows:

1. Open **Settings** by searching for `ms-settings:developers` in the Windows search bar.
2. Navigate to **For Developers** and ensure Developer Mode is enabled.

#### macOS:

1. Open **System Preferences**.
2. Select **Security & Privacy**.
3. Click on the lock icon and enter your password if prompted.
4. Under the **General** tab, click **Allow** next to "App Store and identified developers".

#### Linux:

1. Open your terminal and run the following command:
   ```bash
   gnome-control-center apps
   ```
2. Enable Development Mode if it's not already enabled.

---

## Firebase Setup

1. **Install Firebase CLI:**

   ```bash
   npm i firebase
   ```

   ```bash
   npm i -g firebase-tools
   ```

2. **Login to Firebase:**

   ```bash
   firebase login
   ```

3. **Install flutterfire_cli:**

   - Execute the following command:

   ```bash
   dart pub global activate flutterfire_cli
   ```

   On Windows, make sure the `PATH` variable includes the Dart `pub-cache` directory:

   ```bash
   C:\Users\<YourUsername>\AppData\Local\Pub\Cache\bin
   ```

   Verify installation by running:

   ```bash
   flutterfire --version
   ```

   (If the command doesn’t work, restart your PC to refresh environment variables.)

4. **Configure FlutterFire:**

   - Execute the following command:
     ```bash
     flutterfire configure
     ```
   - Follow the prompts to select or create a Firebase project.
   - When prompted to select environments for registration, navigate through the list of available environments (e.g., web) using the arrow keys:
     - Press the **space key** to select only the desired environment and deselect others.
   - This step will generate the required configuration files, such as:
     - `google-services.json` for Android.
     - `GoogleService-Info.plist` for iOS.

### Firestore Setup

1. Go to the [Firebase Console](https://console.firebase.google.com).
2. Select your project.
3. Navigate to **Firestore Database** in the left-hand menu.
4. Click **Create Database**.
5. Select the region for your Firestore database and confirm.
6. Choose a mode for your database (e.g., **Test Mode** for development).

This creates the database that your app will interact with.

---

## API Key Setup for OpenWeatherMap

### Create an OpenWeatherMap Account

1. Go to the [OpenWeatherMap website](https://openweathermap.org/).
2. Click **Sign Up** and create a free account.
3. After signing in, navigate to the **API Keys** section of your account dashboard.
4. Copy the API key provided (Notice that the key is only ativated after a few hours) and save it for later use.

---

## Additional Configuration

1. **Environment Variables:**

   - For web applications, ensure all required API keys and environment variables are set up in a `config.json` file. The `config.json` file should be structured as follows:

     ```json
     {
       "API_KEY": "your_api_key_here"
     }
     ```

   - Place the `config.json` file in the appropriate directory and ensure it is properly referenced in your code to load the configuration settings.

2. **Set PATH for Dart and Flutter (if not already set):**

   - Add the following to your PATH environment variable (Windows):

     ```
     C:\flutter\bin
     ```

   - For macOS/Linux, add this to your shell profile:
     ```bash
     export PATH="$PATH:/path/to/flutter/bin"
     ```

3. **Hot Restart:**
   If you encounter any issues during runtime, perform a hot restart:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

## Troubleshooting

- **Firebase Error:** Ensure your `google-services.json` or `GoogleService-Info.plist` file is correctly placed.
- **Provider Issues:** Restart the app using:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```
- **Dependency Issues:** Run:
  ```bash
  dart pub upgrade
  ```

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)

---

## Run the Application

1. **Ensure all dependencies are installed:**

   ```bash
   flutter pub get
   ```

2. **Run the application on an emulator or device:**
   ```bash
   flutter run
   ```
   - Select the desired emulator or device to run the app (e.g., Edge, Chrome, etc.).

Now the `AirGuard WebApp` is ready to run!
