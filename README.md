# Imposter Who 🕵️‍♂️ (v2.0.0)

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange.svg)](https://firebase.google.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

**Imposter Who** is an adrenaline-pumping, highly dynamic social deduction party game built natively in Flutter. What started as a local "Pass-and-Play" phone game has now evolved into a massive fully-networked real-time multiplayer application powered by Firebase!

Play locally with friends on the couch, or spin up private Cloud Lobbies to play across the world asynchronously via Discord or built-in Turned-Based chat modes.

---

## ✨ Features (Version 2.0.0 Update)

### 🌍 Real-Time Online Multiplayer (NEW!)
- **Self-Cleaning Cloud Lobbies**: Generate instant 5-digit Room Codes. The Firestore architecture automatically sweeps and cleans orphaned rooms, costing zero backend footprint.
- **Anonymous Architecture**: No logins, no passwords, no emails. The backend generates secure UIDs directly to device hashes for frictionless onboarding.
- **Dynamic Avatar Hub**: Personalize your identity with 16 synced grid avatars.
- **Strict Network Synchronicity**: The lobby securely prevents out-of-bounds starts and maps turn-taking indices natively via Streams, allowing users to watch exactly whose turn it is to type or speak in real-time.
- **Target Voting Engine**: Lock your suspicions using the cross-device Grid View. Track readiness pings and watch the network trigger the massive Final Reveal when majority resolves!

### 📱 Local "Pass-the-Phone" Mode (Offline)
- **Zero Internet Required**: Take it on roadtrips, camping, or flights.
- **Intelligent Dictionary System**: Access over 21 diverse categories injected via python scripting (`generate_words.py`), ranging from historical figures to brutal abstract concepts.
- **Card-Swiping UX**: Featuring completely custom fluid swipe gestures and tactile card reveals to hide secrets from peeking eyes.

---

## 🎨 Design Philosophy
The entire application UI ditches default Material behaviors and embraces a premium Cyberpunk-lite Charcoal & Lime Green aesthetic (`AppTheme.dart`). The typography relies on massive contrast scaling, subtle drop shadows, and heavy widget animations via `flutter_animate` to ensure every single interaction feels intensely punchy and satisfying.

---

## 🚀 Setup & Installation

**Prerequisites:** You must have Flutter & Dart SDKs configured, as well as a Google Firebase Account for online capabilities.

### 1. Clone the repository
```bash
git clone https://github.com/YourUsername/ImposterWho.git
cd ImposterWho
```

### 2. Fetch Dependencies
```bash
flutter pub get
```

### 3. Initialize Firebase (Mandatory for Online Play)
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
*(Select your Firebase Test-Mode Project with Anonymous Authentication Enabled)*

### 4. Build and Run!
```bash
flutter run
```

---

## 🏗 System Architecture
Imposter Who is entirely reliant on the native `ChangeNotifierProvider` architecture combined natively with `StreamSubscriptions` linking to Firestore document snapshots.

Data schemas strictly separate `RoomSettings`, `RoomPlayer`, and global `Room` states to enforce complete network safety preventing split-brain game scenarios.

---

## 📄 License
This codebase is completely Open Source operating entirely under the **MIT License**. Use it, break it, port it, deploy it!
