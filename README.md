# Dashboard Flutter 

A simple dashboard app built with **Flutter** that displays sales and task data using beautiful charts and legends. Data is fetched live from **Firebase Firestore** and visualized using the [`fl_chart`](https://pub.dev/packages/fl_chart) package.

## Features

- **Bar Chart** for yearly sales
- **Pie Chart** for daily tasks
- **Horizontal legends** with color indicators for each chart
- Live data updates from Firestore

## Screenshots

| Sales Chart with Legend | Tasks Pie Chart with Legend |
|------------------------|----------------------------|
| ![image](https://github.com/user-attachments/assets/bd395e86-d275-4b43-bf5b-d69ec06037b0)| ![image](https://github.com/user-attachments/assets/f2735666-5cf8-4c3f-b3b2-4d9bd788ce4b)|

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase Project](https://console.firebase.google.com/)
- Your Firestore collections: `sales` and `task`

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/dashboard-flutter.git
   cd dashboard-flutter
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Firebase Setup:**
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) as per [FlutterFire docs](https://firebase.flutter.dev/docs/overview).
   - Update `firebase_options.dart` if needed.

4. **Firestore Structure Example:**

   - **sales** collection:
     ```json
     {
       "saleYear": 2015,
       "saleVal": 120,
       "colorVal": "0xFF4CAF50"
     }
     ```
   - **task** collection:
     ```json
     {
       "taskdetails": "Meeting",
       "taskVal": 3,
       "colorVal": "0xFF2196F3"
     }
     ```

5. **Run the app:**
   ```sh
   flutter run
   ```

## Project Structure

```
lib/
  main.dart
  dashboard_homepage.dart
  sales.dart
  task.dart
pubspec.yaml
```

## Dependencies

- [fl_chart](https://pub.dev/packages/fl_chart)
- [firebase_core](https://pub.dev/packages/firebase_core)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)

## Customization

- Change chart colors by updating the `colorVal` field in Firestore.
- Add or remove years/tasks directly in Firestore for live updates.

## License

This project is licensed under the MIT License.

---

**Made with Flutter & Firebase**
