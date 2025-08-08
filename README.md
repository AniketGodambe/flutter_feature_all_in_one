# 📱 Flutter Feature All-in-One

A Flutter application showcasing multiple essential device integrations, each demonstrated with clear, working source code examples. This project is designed to be modular and easy to understand, making it perfect for learning or integrating into larger apps.

🚀 Features with Code Samples

### 🔹 1. Select Image From Device

**📋 Description:**

Users can select and display images from their device gallery or capture photos using the camera, powered by the image_picker package.

🔐 Required Permissions:

**Android**

android.permission.READ_EXTERNAL_STORAGE

android.permission.CAMERA

**iOS**

NSPhotoLibraryUsageDescription

NSCameraUsageDescription

### 🔹 2. Fetch Contacts From Device

**📋 Description:**

Displays the user's contact list using the contacts_service package. Demonstrates how to fetch and display contacts on both Android and iOS devices.

🔐 Required Permissions:

**Android**

android.permission.READ_CONTACTS

**iOS**

NSContactsUsageDescription

### 🔹 3. List Pagination with API

**📋 Description:**

Demonstrates paginated list loading using API data. Fetches data page-by-page and renders it in a scrollable, performant list view.

🔐 Required Permissions:

Android & iOS: No special permissions required.

🛠 Setup Instructions
Add required dependencies in your pubspec.yaml file.

Update permissions in the following files:

AndroidManifest.xml (for Android)

Info.plist (for iOS)

### 🔹 2. Fetch Contacts From Device

**📋 Description:**

Displays the user's contact list using the contacts_service package. Demonstrates how to fetch and display contacts on both Android and iOS devices.

🔐 Required Permissions:

**Android**

android.permission.READ_CONTACTS

**iOS**

NSContactsUsageDescription

### 🔹 4. Bio Metric Feature

**📋 Description:**

To add biometric authentication in a Flutter app, the most common and straightforward way is to use the local_auth Flutter package, which supports fingerprint, face ID, and device credentials (PIN, pattern, or passcode)

🔐 Required Permissions:

Android & iOS: No special permissions required.

🛠 Setup Instructions
Add required dependencies in your pubspec.yaml file.

Update permissions in the following files:

AndroidManifest.xml (for Android)

Info.plist (for iOS)

### 🔹 4. Open Street Map Integration

**📋 Description:**

This Flutter app integrates Open Street Map (OSM) to provide interactive and customizable mapping features. Open Street Map is an open-source map service that allows users to display detailed maps, add markers, draw routes, and interact with geographical data within the app.

🗺 Features include:

Displaying maps using Open Street Map tiles.

Adding custom markers and annotations.

User location tracking.

Zooming and panning capabilities.

Route plotting and map overlays.

🔐 Required Permissions:

Android: Access to location services (e.g., ACCESS_FINE_LOCATION or ACCESS_COARSE_LOCATION) if you want to track user location.

iOS: Location permissions in Info.plist (e.g., NSLocationWhenInUseUsageDescription) for location tracking features.

🛠 Setup Instructions:

Add the Open Street Map related dependencies to your pubspec.yaml file (e.g., flutter_osm_plugin or any OSM Flutter package being used).

Update Android permissions in AndroidManifest.xml if location tracking is implemented.

Update iOS permissions in Info.plist if location tracking is implemented.

Initialize the map widget and configure it according to your app's requirements.

This setup enables comprehensive Open Street Map functionality in your Flutter app for enhanced location-based experiences.
Refer to the feature-specific source code files for exact implementations and usage examples.

## 📌 Notes

Always request permissions at runtime using packages like permission_handler where required.
