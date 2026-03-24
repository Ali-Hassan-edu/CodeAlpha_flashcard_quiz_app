<div align="center">

<br/>

```
███████╗██╗      █████╗ ███████╗██╗  ██╗███╗   ███╗██╗███╗   ██╗██████╗
██╔════╝██║     ██╔══██╗██╔════╝██║  ██║████╗ ████║██║████╗  ██║██╔══██╗
█████╗  ██║     ███████║███████╗███████║██╔████╔██║██║██╔██╗ ██║██║  ██║
██╔══╝  ██║     ██╔══██║╚════██║██╔══██║██║╚██╔╝██║██║██║╚██╗██║██║  ██║
██║     ███████╗██║  ██║███████║██║  ██║██║ ╚═╝ ██║██║██║ ╚████║██████╔╝
╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═════╝
```

### ⚡ Study smarter, not harder

<br/>

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-6.1-7C3AED?style=for-the-badge&logo=flutter&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-22C55E?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-F59E0B?style=for-the-badge&logo=android&logoColor=white)

<br/>

> A beautiful, fully-featured flashcard quiz app built with Flutter.  
> Created as **Task 1** of the [CodeAlpha](https://www.codealpha.tech) App Development Internship.

<br/>

</div>

---

## 📸 Screenshots

<br/>

> **Note:** Run the app and replace these placeholders with your actual screenshots.

<br/>

<div align="center">

| Home / Quiz Screen | Answer Revealed | Side Drawer |
|:------------------:|:---------------:|:-----------:|
| ![Quiz Screen](screenshots/quiz_screen.png) | ![Answer](screenshots/answer_revealed.png) | ![Drawer](screenshots/drawer.png) |

| Manage Cards | Add New Card | Dark Mode |
|:------------:|:------------:|:---------:|
| ![Manage](screenshots/manage_screen.png) | ![Add Card](screenshots/add_card.png) | ![Dark](screenshots/dark_mode.png) |

</div>

<br/>

> **How to take screenshots:**  
> Run the app → use `flutter screenshot` or press the screenshot button on your emulator.  
> Save them in a `/screenshots` folder in your project root.

---

## ✨ Features

<br/>

| Feature | Description |
|---------|-------------|
| 🃏 **3D Flip Animation** | Smooth Y-axis card flip with cubic easing — question on front, answer on back |
| ➕ **Add Cards** | Create new flashcards via FAB button or the quick-add sheet |
| ✏️ **Edit Cards** | Update any card's question or answer at any time |
| 🗑️ **Delete Cards** | Remove cards with a confirmation dialog to prevent accidents |
| 💾 **Persistent Storage** | Cards are saved locally using `SharedPreferences` — survive app restarts |
| 🎨 **Light & Dark Theme** | Fully themed for both modes — auto-switches with your phone setting |
| 📊 **Dot Progress Indicator** | Animated dot pills showing your position in the deck |
| 🗂️ **Custom Side Drawer** | Gradient sidebar with navigation, stats, and card count |
| ⚡ **Quick Add Sheet** | Add a card without leaving the quiz screen via the `+` header button |
| 🔄 **Wrap-around Navigation** | Next/Prev buttons cycle endlessly through the deck |

---

## 🏗️ Project Structure

```
flashcard_quiz_app/
│
├── lib/
│   ├── main.dart                        # App entry point + full Light & Dark theme
│   │
│   ├── models/
│   │   └── flashcard.dart               # Flashcard data model (id, question, answer)
│   │
│   ├── providers/
│   │   └── flashcard_provider.dart      # All state logic — add, edit, delete, flip, save
│   │
│   ├── widgets/
│   │   ├── flashcard_widget.dart        # Animated 3D flip card component
│   │   └── app_drawer.dart              # Custom side drawer with gradient header
│   │
│   └── screens/
│       ├── quiz_screen.dart             # Main study screen
│       └── manage_screen.dart           # Add / Edit / Delete cards screen
│
├── screenshots/                         # App screenshots for README
├── pubspec.yaml                         # Dependencies
└── README.md
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.x** | UI framework — cross-platform (Android + iOS) |
| **Dart 3.x** | Programming language |
| **Provider 6.1** | State management — shares data across all screens |
| **SharedPreferences 2.3** | Local key-value storage — persists card data |
| **Google Fonts 6.2** | Typography — Plus Jakarta Sans + Nunito |
| **Material 3** | Design system with full light/dark support |

---

## 🚀 Getting Started

### Prerequisites

Make sure you have Flutter installed and set up:

```bash
flutter doctor
```

All items should show ✅. If not, follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/CodeAlpha_FlashcardQuizApp.git
cd CodeAlpha_FlashcardQuizApp
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run the app**

```bash
# On connected device or emulator
flutter run

# Specifically on Android
flutter run -d android

# Specifically on iOS
flutter run -d ios
```

**4. Build APK (for submission)**

```bash
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  provider: ^6.1.2           # State management
  shared_preferences: ^2.3.2  # Local storage
  google_fonts: ^6.2.1        # Beautiful typography
```

---

## 🎯 How It Works

### Architecture — Provider Pattern

```
┌─────────────────────────────────────────────┐
│               FlashcardProvider              │
│  • holds List<Flashcard>                     │
│  • currentIndex, showAnswer                  │
│  • add / edit / delete / flip / navigate     │
│  • save to & load from SharedPreferences     │
└────────────────┬────────────────────────────┘
                 │  context.watch / context.read
        ┌────────┴────────┐
        ▼                 ▼
  QuizScreen        ManageScreen
  (reads state)     (mutates state)
```

### Card Flip Animation

The flip uses Flutter's `AnimationController` with a `Matrix4.rotateY()` transform:

```dart
// 0.0 = front face (question)
// π   = back face (answer)
_animation = Tween<double>(begin: 0, end: math.pi).animate(
  CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
);
```

Once the rotation passes `π/2` (halfway), the widget switches from the front face to the back face, and counter-rotates by `π` so the text isn't mirrored.

---

## 📋 Task Requirements Checklist

This project was built for **Task 1: Flashcard Quiz App** from CodeAlpha.

| Requirement | Status |
|-------------|--------|
| Flashcard with question on front | ✅ Done |
| "Show Answer" button reveals back | ✅ Done |
| Next and Previous navigation | ✅ Done |
| Add new flashcards | ✅ Done |
| Edit existing flashcards | ✅ Done |
| Delete flashcards | ✅ Done |
| Simple and clean UI | ✅ Done |

**Bonus features added beyond requirements:**

| Bonus | Details |
|-------|---------|
| 3D flip animation | Smooth cubic-eased Y-axis rotation |
| Light & Dark theme | Auto-detects phone system setting |
| Dot progress indicator | Animated pill-shaped position tracker |
| Persistent storage | Cards saved between app sessions |
| Custom side drawer | Gradient header with stats & navigation |
| Quick-add bottom sheet | Add cards without leaving quiz screen |

---

## 🎓 Internship Info

<div align="center">

| | |
|--|--|
| **Company** | CodeAlpha |
| **Domain** | App Development |
| **Task** | Task 1 — Flashcard Quiz App |
| **Framework** | Flutter (Dart) |
| **Website** | [www.codealpha.tech](https://www.codealpha.tech) |

</div>

---

## 📁 GitHub Repository Name

As per CodeAlpha internship guidelines, this repository is named:

```
CodeAlpha_FlashcardQuizApp
```

---

## 👤 Author

<div align="center">

**Your Name**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/YOUR_USERNAME)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/YOUR_USERNAME)

</div>

---

## 📄 License

```
MIT License — free to use, modify, and distribute.
```

---

<div align="center">

Made with ❤️ using Flutter &nbsp;•&nbsp; CodeAlpha Internship 2024

⭐ Star this repo if you found it helpful!

</div>
