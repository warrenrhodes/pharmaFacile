# PharmaFacile

A modern, intuitive Pharmacy Management Application built with Flutter, shadcn_flutter, Firebase, and Riverpod.

## Features

- Modern UI inspired by shadcn/ui
- Firebase Authentication (PIN/Password)
- Cloud Firestore for products, sales, and users
- Local notifications for low stock alerts
- PDF report generation and printing
- Robust state management with Riverpod
- Responsive design for mobile, tablet, and desktop

## Setup Instructions

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)

### Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Authentication** (Email/Password or custom PIN logic).
3. Enable **Cloud Firestore**.
4. Run `flutterfire configure` in your project directory to generate `lib/config/firebase_options.dart`.
5. Add `google-services.json` (Android) to `android/app/` and `GoogleService-Info.plist` (iOS) to `ios/Runner/`.

### Install Dependencies

```
flutter pub get
```

## How to Run

```
flutter run
```

## Usage

- **Login:** Enter your PIN or password to access the app.
- **Dashboard:** Quick access to sales, stock, reports, and settings.
- **Sales:** Record new sales, view daily sales history.
- **Stock:** Manage products, add/edit/delete, and get low stock alerts.
- **Reports:** Generate and export PDF sales reports.
- **Settings:** Backup/restore data, change PIN, and more.

## Authentication

- Simple PIN/Password login using Firebase Authentication.
- After successful login, you are redirected to the dashboard.
- If not authenticated, the login screen is always shown.

## Firebase Security

See `firestore.rules` for recommended security rules.

---

**Note:** This project uses the `shadcn_flutter` package for a modern, consistent UI. All user dialogs and confirmations use `ShadAlertDialog` instead of native alerts.
