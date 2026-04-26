<div align="center">
  <img src="assets/icon.png" width="128" alt="Imposter Who Icon"/>
  <h1>Imposter Who</h1>
  <p><strong>A Modern, Offline-First Social Deduction Party Game Built with Flutter</strong></p>
</div>

---

## 🕵️‍♂️ About The Game

**Imposter Who** is an engaging, pass-and-play social deduction game designed perfectly for parties, hangouts, and game nights. Completely inspired by the intense nature of finding the odd one out, players take turns looking at their assigned word while the hidden imposters get only a vague hint. The catch? The imposters must blend in during the discussion phase to avoid being caught!

### ✨ Key Features

- **100% Offline Gameplay**: No authentication, no servers, no internet required. Play it anywhere, anytime.
- **Dynamic Word Generation Script**: Ships with a curated, high-quality, and robust offline word dictionary generating over 1500+ items across 21 unique categories.
- **Pass & Play Mechanics**: Features smooth swipe-to-reveal mobile gestures keeping player roles secret.
- **Auto-Scaling Difficulty**: The game intelligently calculates the maximum number of imposters based on your party size (supports 3–20 players).
- **Stunning UI/UX Aesthetics**: Features a highly polished, interactive "Neo-Cream & Lime" visual language providing intense feedback through micro-animations via `flutter_animate`.

---

## 📸 Screenshots

*(Replace with actual gameplay screenshots of the Main Menu, Setup, and Reveal phases!)*

<kbd>
<img src="assets/icon.png" width="200" alt="Main UI"/>
</kbd>

---

## 🎮 How to Play

1. **Setup**: Select up to 3 word categories, enter the number of players, and choose how many imposters are hiding among you. 
2. **Review Roles**: Pass the phone around. Each player uses the **Swipe-to-Reveal** card to privately view their word. (Citizens see the exact Word, Imposters see a vague Hint).
3. **Discuss**: The game will randomly choose a player to speak first. Everyone must describe their word without giving it away too specifically!
4. **Hunt the Imposter**: As a group, decide who you think is faking it. 
5. **Reveal**: Hold down the final screen button to reveal who the true imposters were!

---

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)**: For a blazingly fast, multi-platform UI.
- **[Provider](https://pub.dev/packages/provider)**: For robust, decoupled state management.
- **[Flutter Animate](https://pub.dev/packages/flutter_animate)**: For fluid, chainable layout and micro-interaction animations.
- **Python**: Used exclusively to rigorously curate and structure internal JSON payload generation (`generate_words.py`).

---

## 🚀 Getting Started

### Prerequisites
Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YourUsername/ImposterWho.git
   cd ImposterWho
   ```

2. **Fetch Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **(Optional) Re-generate Offline Dictionary:**
   If you wish to modify the word dictionary or hints, edit `generate_words.py` and run:
   ```bash
   python3 generate_words.py
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE). 
