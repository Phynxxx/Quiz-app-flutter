# QuizMaster Pro

A polished Flutter quiz app built from the QuizMaster Pro PRD.

Each session loads **10 randomized questions** from a **100-question bank**, supports **timed questions (30s each)**, includes a **smart hint system** (auto-reveal at 15s, max 3 hints/session), and ends with a themed results experience.

---

## ✨ Features

- **Randomized quiz sessions**
	- 10 questions per run, selected from 100 questions.
	- Answer options are shuffled per question (correct option is not fixed to one position).

- **Timer-driven gameplay**
	- 30 seconds per question.
	- If no answer is selected before time expires, the question is auto-submitted as incorrect.

- **Hint system**
	- Auto hint appears after 15 seconds of inactivity.
	- Manual hint button available.
	- Global cap of 3 hints per quiz session.

- **Themed UI (PRD-aligned tokens)**
	- Centralized app theme with color, typography, spacing, radius, and shadow tokens.
	- Dark premium visual style with reusable widgets.

- **Structured screen flow**
	- Animated splash screen.
	- Quiz screen with question card, countdown indicator, hint state, and progress bar.
	- Results screen with score summary and replay flow.

---

## 🧱 Tech Stack

- **Framework:** Flutter
- **Language:** Dart
- **State pattern (current):** Stateful widget orchestration
- **Fonts:** `google_fonts`
- **Assets:** JSON question bank (`assets/data/questions.json`)
- **Testing:** `flutter_test`

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   └── question_repository.dart
├── models/
│   └── question.dart
├── screens/
│   ├── splash_screen.dart
│   ├── quiz_screen.dart
│   └── result_screen.dart
├── widgets/
│   ├── answer_button.dart
│   ├── question_card.dart
│   └── score_circle.dart
└── main.dart

assets/
└── data/
		└── questions.json

test/
├── data/
│   └── repository_test.dart
└── widget_test.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed and available in `PATH`
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code with Flutter extensions

> Current `pubspec.yaml` Dart constraint: `>=2.19.4 <3.0.0`

### Install dependencies

Run dependency install in the project root:

`flutter pub get`

### Run the app

`flutter run`

### Run tests

`flutter test`

---

## 🎮 Gameplay Rules

- 10 questions per session.
- Each question has 4 options.
- Correct answer scores `10`, incorrect/timeout scores `0`.
- Max score per session: `100`.
- Pass threshold: `50`.
- Hint budget: `3` total per session.

---

## 🧠 Question Bank & Randomization

- Question data is loaded from `assets/data/questions.json` into memory via `QuestionRepository`.
- Session generation logic:
	1. Shuffle question list.
	2. Take the first 10.
	3. Shuffle answer options for each selected question.
	4. Attach/generate a hint (fallback hint is generated when missing).

This ensures:
- No fixed correct-answer position pattern.
- High replayability.

---

## 🎨 Design System Notes

All visual tokens are centralized in:

- `lib/core/theme/app_theme.dart`

This includes:
- `AppColors`
- `AppTypography`
- `AppSpacing`
- `AppRadius`
- `AppShadows`

Use these tokens in widgets to avoid hardcoded style values.

---

## ✅ Test Coverage (Current)

- Repository tests validate:
	- JSON loading and initialization
	- session randomization
	- category filtering/statistics
	- answer-order randomization behavior
	- hint availability

- Widget tests validate:
	- splash rendering and transition
	- quiz rendering with custom widgets
	- theme application

Run all tests with:

`flutter test`

---

## 📌 PRD Alignment Status

Implemented in current version:
- 10 random questions from 100
- themed splash/quiz/results flow
- answer randomization
- timer + hint mechanics
- reusable theme system

Planned / partial from PRD (future iterations):
- Home/Landing screen with best-score persistence
- Riverpod architecture migration
- advanced animation sequencing via a single controller + intervals
- go_router navigation guards
- confetti celebration and detailed score breakdown list

---

## 🤝 Contributing

1. Create a feature branch.
2. Keep changes focused and testable.
3. Run `flutter test` before opening a PR.
4. Follow existing theme-token usage (avoid hardcoded styling).

---

## 📄 License

This repository currently has no explicit license file.
If you plan to open-source the project, add a `LICENSE` file (e.g., MIT/Apache-2.0).
