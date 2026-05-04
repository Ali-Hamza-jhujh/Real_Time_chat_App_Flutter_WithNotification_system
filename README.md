# 💬 Real-Time Chat App — Flutter + Node.js

A full-stack real-time chat application built with **Flutter** and a **Node.js** backend, featuring push notifications, voice recording, and a rich messaging experience.

---

## ✨ Features

- 🔐 **Authentication** — Register and login with secure user sessions
- 💬 **Real-Time Messaging** — Instant chat powered by Socket.IO / WebSockets
- 🔔 **Push Notifications** — Get notified of new messages even when the app is in the background
- 🎙️ **Voice Recorder** — Send voice messages directly from the chat screen
- 👤 **User Profiles** — View and manage your profile
- 🏠 **Home & Drawer Navigation** — Clean navigation with a sidebar drawer
- 📱 **Cross-Platform** — Runs on Android, iOS, Linux, macOS, Web, and Windows

---

## 🗂️ Project Structure

```
├── Backened/                   # Node.js backend
│   ├── authentication/         # Auth routes & middleware
│   ├── models/                 # Database models
│   ├── node_code/              # Core server logic
│   ├── db.js                   # Database connection
│   ├── index.js                # Express app entry point
│   └── package.json
│
├── lib/
│   ├── main.dart               # App entry point
│   ├── notification.dart       # Push notification handler
│   └── secreen/
│       └── components/
│           ├── login.dart          # Login screen
│           ├── register.dart       # Registration screen
│           ├── home.dart           # Home screen
│           ├── screenchat.dart     # Chat screen
│           ├── charapp.dart        # Chat app logic
│           ├── profile.dart        # User profile screen
│           ├── Drawer_page.dart    # Side drawer navigation
│           ├── appbar.dart         # Custom app bar
│           ├── notification.dart   # In-app notification UI
│           ├── voicerecoder.dart   # Voice recording component
│           ├── routers.dart        # App routing
│           └── states.dart         # State management
│
├── android/                    # Android platform files
├── ios/                        # iOS platform files
├── web/                        # Web platform files
├── pubspec.yaml                # Flutter dependencies
└── .env                        # Environment variables
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.x or later)
- [Node.js](https://nodejs.org/) (v18 or later)
- A Firebase project (for push notifications)
- MongoDB or your configured database

---

### 🔧 Backend Setup

```bash
cd Backened
npm install
```

Create a `.env` file in the `Backened/` directory:

```env
PORT=5000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
```

Start the server:

```bash
node index.js
```

---

### 📱 Flutter Setup

1. Install dependencies:

```bash
flutter pub get
```

2. Configure your `.env` or update the API base URL inside the project to point to your backend server.

3. Set up Firebase:
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

4. Run the app:

```bash
flutter run
```

---

## 🔔 Notifications

This app uses **Firebase Cloud Messaging (FCM)** for push notifications. Make sure your backend is configured to send FCM messages when a new chat message is received.

Notification handling is managed in:
- `lib/notification.dart` — FCM initialization and foreground handling
- `lib/secreen/components/notification.dart` — In-app notification UI

---

## 🛠️ Tech Stack

| Layer       | Technology              |
|-------------|-------------------------|
| Frontend    | Flutter (Dart)          |
| Backend     | Node.js + Express       |
| Real-Time   | Socket.IO / WebSockets  |
| Database    | MongoDB                 |
| Auth        | JWT                     |
| Notifications | Firebase FCM          |

---

## 📸 Screens

| Screen       | File                  |
|--------------|-----------------------|
| Login        | `login.dart`          |
| Register     | `register.dart`       |
| Home         | `home.dart`           |
| Chat         | `screenchat.dart`     |
| Profile      | `profile.dart`        |
| Drawer       | `Drawer_page.dart`    |

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

This project is open source. See [LICENSE](LICENSE) for details.

---

> Built with ❤️ using Flutter & Node.js
