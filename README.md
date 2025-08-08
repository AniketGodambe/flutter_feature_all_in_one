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

Refer to the feature-specific source code files for exact implementations and usage examples.

📌 Notes
Always request permissions at runtime using packages like permission_handler where required.

All code is modular, well-commented, and designed for easy integration and learning.

This project is ideal for beginners exploring device integrations or teams building feature-rich apps.

Feel free to contribute or customize features as per your project needs. Happy coding! 🚀
