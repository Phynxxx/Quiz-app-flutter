# QuizMaster Pro
## Product Requirements Document (PRD)
### Flutter Quiz Application · Version 1.0 · April 2026

---

> **Document Status:** Final Draft  
> **Platform:** Flutter (iOS + Android)  
> **Prepared For:** Engineering & Design Team  
> **Classification:** Internal — Confidential

---

## Table of Contents

1. [Executive Overview & Product Vision](#1-executive-overview--product-vision)
2. [Design System & Visual Language](#2-design-system--visual-language)
3. [Screen-by-Screen Specifications](#3-screen-by-screen-specifications)
4. [Animation Specifications](#4-animation-specifications)
5. [Question Bank Architecture](#5-question-bank-architecture)
6. [User Stories & Acceptance Criteria](#6-user-stories--acceptance-criteria)
7. [State Management & App Architecture](#7-state-management--app-architecture)
8. [Technical Specifications & Package List](#8-technical-specifications--package-list)
9. [End-to-End User Flow](#9-end-to-end-user-flow)
10. [Testing Requirements](#10-testing-requirements)
11. [Accessibility & Localization](#11-accessibility--localization)
12. [Delivery Milestones & Definition of Done](#12-delivery-milestones--definition-of-done)

---

## 1. Executive Overview & Product Vision

### 1.1 Product Summary

QuizMaster Pro is a cross-platform mobile quiz application built with Flutter. Its central promise is a polished, friction-free experience: each session presents **10 questions drawn at random from a bank of 100**, guides the user through a smooth animated loop, and delivers a clear, satisfying results screen with a one-tap reset. The product targets trivia enthusiasts and casual learners aged 13 and above.

The app has no login wall, no ads, and no onboarding friction — the user is one tap away from their first question from the moment the app opens.

### 1.2 Strategic Goals

The four non-negotiable product goals that every design and engineering decision must serve are:

**Goal 1 — Speed:** Deliver an end-to-end quiz loop that a user can complete in under 5 minutes, with zero loading screens after the initial launch.

**Goal 2 — Delight:** Set a design standard that feels closer to a premium mobile game than a utility app. Every tap, every transition, and every result must feel intentional and satisfying.

**Goal 3 — Scalability:** Establish a question-bank architecture that can grow from 100 to 1,000+ questions in a future version without structural changes to the codebase.

**Goal 4 — Performance:** Achieve a smooth, uninterrupted 60 fps animation budget on mid-range Android devices (e.g., Samsung Galaxy A-series running Android 10+).

### 1.3 Target Audience

The app serves three primary user segments, each with distinct motivations:

| Segment | Profile | Key Need |
|---|---|---|
| Casual Learner | Ages 16–35, plays during commutes or short breaks | Quick, rewarding sessions with immediate visual feedback |
| Trivia Enthusiast | Ages 18–45, motivated by score improvement and variety | Diverse question pool, share-worthy results, high-score tracking |
| Student | Ages 13–22, uses the app for light topic revision | Categorized questions, clear progress indicators, educational answer reveals |

### 1.4 Out of Scope for v1.0

The following features are intentionally deferred to keep the first release focused and shippable. They are strong candidates for v1.1 and must be accounted for in architectural decisions (i.e., don't build in ways that would block them):

User accounts, authentication, or cloud sync are excluded. Multiplayer or head-to-head modes are excluded. In-app purchases or monetization are excluded. Push notifications and scheduled reminders are excluded. Custom question creation by the user is excluded.

---

## 2. Design System & Visual Language

The design system is the **single source of truth** for every visual decision in the app. The developer must implement all tokens defined here in a dedicated file (`lib/core/theme/app_theme.dart`) and must **never use hard-coded color, font, or spacing values** anywhere in the widget tree. This is a hard requirement, not a guideline.

### 2.1 Design Philosophy

The visual language of QuizMaster Pro follows four governing principles:

**Modern Minimalism** means every element on screen has earned its place. Remove anything decorative that does not serve orientation, clarity, or delight. Surfaces are clean and uncluttered.

**Depth Through Layer, Not Decoration** means visual hierarchy is communicated through shadow, blur, and z-layering — not through busy borders, gradients on every element, or excessive iconography.

**Motion as Communication** means every user action receives animated acknowledgment, however brief. Animation is never gratuitous; it always tells the user what just happened or what is about to happen.

**Accessibility First** means all text must meet WCAG AA contrast ratios (4.5:1 minimum) against their backgrounds. Accessible design is not a post-launch concern; it is baked in from the first widget.

### 2.2 Color Palette

Every color used in the application must map to one of the following tokens. The developer must define these as named constants in `AppColors` and expose them through `ThemeData.colorScheme`.

| Token | Hex | Role | Where It's Used |
|---|---|---|---|
| `primaryColor` | `#6C63FF` | Brand / Primary CTAs | Buttons, active states, progress bars, links |
| `accentColor` | `#FF6584` | Emotional Highlight | Incorrect answer flash, warning badges, energy |
| `backgroundColor` | `#1A1A2E` | Scaffold / Canvas | The dark base of every screen |
| `surfaceColor` | `#2D2D44` | Cards & Tiles | Question cards, option tiles, bottom sheets |
| `surfaceVariant` | `#363656` | Elevated Surfaces | Modals, overlapping cards, popovers |
| `successColor` | `#10B981` | Correct Answer | Correct option highlight, score circle (high score) |
| `warningColor` | `#F59E0B` | Mid Performance | Score circle (mid score), timer urgency |
| `onBackground` | `#F0EEFF` | Primary Text | All body and heading text on dark surfaces |
| `subtitleColor` | `#9CA3AF` | Secondary Text | Hints, metadata, captions, placeholders |
| `borderColor` | `#3F3F60` | Subtle Dividers | Tile borders in idle state, section separators |

### 2.3 Typography Scale

The app uses two typefaces loaded via the `google_fonts` package. **Poppins** handles all display, heading, and button text — its geometric personality conveys confidence and energy. **Inter** handles all body and label text — its optical precision makes it highly legible at small sizes on OLED screens.

**Critical rule:** never fall back to system fonts. Fonts must be loaded at app startup and cached locally. If a font fails to load, the app must still render — define a system-font fallback chain in the theme, but log the failure.

| Style Token | Typeface | Weight | Size | Letter Spacing | Usage |
|---|---|---|---|---|---|
| `displayLarge` | Poppins | Bold 700 | 48 sp | −0.5 | Score result number in circle |
| `headlineLarge` | Poppins | SemiBold 600 | 28 sp | −0.3 | Screen titles, splash headline |
| `headlineMedium` | Poppins | SemiBold 600 | 22 sp | −0.2 | Question text on card |
| `titleMedium` | Poppins | Medium 500 | 18 sp | 0 | Card sub-headers, result labels |
| `bodyLarge` | Inter | Regular 400 | 16 sp | 0 | Option text, body copy |
| `bodyMedium` | Inter | Regular 400 | 14 sp | 0.1 | Supporting descriptions |
| `labelMedium` | Inter | Medium 500 | 13 sp | 0.2 | Category chip, metadata |
| `buttonText` | Poppins | Bold 700 | 16 sp | 0.5 | All CTA button labels |

### 2.4 Spacing & Layout Grid

The entire app uses an **8-point grid**. Every padding, margin, gap, and size value must be a multiple of 8 dp. The primary horizontal content padding is `24 dp`. Cards use `16 dp` internal padding. The safe-area-aware bottom padding for bottom-fixed UI elements is `24 dp + MediaQuery.padding.bottom`.

Permitted spacing values are: 4, 8, 12, 16, 20, 24, 32, 40, 48, 56, 64, 80, 96 dp. Developers must not use arbitrary values like 17, 23, or 35.

### 2.5 Elevation & Shadow System

Elevation in this app is expressed through explicit `BoxShadow` definitions rather than Flutter Material's elevation system. This gives precise control over shadow color, which is critical on dark surfaces where black shadows disappear.

All three shadow levels use `primaryColor` with varying opacity, creating a "glow" effect that is on-brand and visually distinctive on dark backgrounds:

**`shadowSm`** — `BoxShadow(offset: Offset(0, 4), blurRadius: 12, color: Color(0x336C63FF))` — used on idle option tiles and small chips.

**`shadowMd`** — `BoxShadow(offset: Offset(0, 8), blurRadius: 24, color: Color(0x4D6C63FF))` — used on question cards and the home hero card.

**`shadowLg`** — `BoxShadow(offset: Offset(0, 16), blurRadius: 40, color: Color(0x666C63FF))` — used on modals, result cards, and the score circle widget.

### 2.6 Shape & Border Radius System

Border radii follow a named scale to ensure consistency across all widgets:

| Token | Value | Used On |
|---|---|---|
| `radiusXs` | 8 dp | Chips, small badges |
| `radiusSm` | 12 dp | Input fields, small buttons |
| `radiusMd` | 14 dp | Option tiles, standard buttons |
| `radiusLg` | 20 dp | Question cards, hero cards |
| `radiusXl` | 28 dp | Bottom sheets, modals |
| `radiusFull` | 999 dp | Circular elements, pill badges |

---

## 3. Screen-by-Screen Specifications

### 3.1 Splash Screen

The splash screen is the app's first impression. It must communicate brand identity, complete data pre-loading, and transition to the home screen — all within **2.2 seconds**. No skip button exists in v1.0.

**Background:** Solid `backgroundColor` (`#1A1A2E`). No image or gradient.

**Logo Animation:** The app icon (a stylized lightning bolt or brain SVG, in `primaryColor` on a `surfaceColor` rounded-square background) fades in from opacity 0 to 1 over **600 ms**, simultaneously scaling from 0.8 to 1.0 using `Curves.elasticOut`. The icon should feel like it snaps into place with slight overshoot.

**App Name Reveal:** "QuizMaster Pro" in `headlineLarge` (Poppins SemiBold). Each letter animates individually — sliding up from 20 dp below its final position and fading in — with a **30 ms stagger** between each character. The full animation takes approximately 500 ms total and begins 200 ms after the logo animation starts.

**Tagline:** "Test Your Mind" in `bodyMedium`, `subtitleColor`, fades in with a 300 ms delay after the last letter of the app name finishes. Duration: 300 ms.

**Progress Bar:** A thin `LinearProgressIndicator` in `primaryColor`, **2 dp height**, centered horizontally and spanning **60% of screen width**, positioned 40 dp below the tagline. It animates from 0% to 100% over **1.8 seconds** and is tied to the actual JSON question bank pre-load. If loading finishes before the animation, the bar completes its visual animation anyway (minimum perceived progress).

**Auto-navigation:** After the progress bar reaches 100%, wait 150 ms, then navigate to the Home screen using a custom cross-fade transition over 400 ms.

**Pre-loading requirement:** During the splash, the app must call `QuizRepository.preloadBank()` which reads `assets/data/questions.json` into memory. All subsequent quiz sessions use the in-memory data — no disk reads during gameplay.

---

### 3.2 Home / Landing Screen

The home screen is the entry point for every quiz session, including sessions after a reset. It must orient the user immediately and make starting a quiz a single, obvious action.

**Background:** An animated ambient background using two overlapping `RadialGradient` painterly blobs — one in deep `primaryColor` (20% opacity) and one in `accentColor` (10% opacity) — that slowly drift in a looping `AnimationController` on a 20-second cycle. On devices where this causes frame drops (profiled below 55 fps in release mode), fall back to a static `LinearGradient` from `backgroundColor` to a dark purple (`#16213E`).

**Hero Card:** A `Card` widget with `radiusLg` (20 dp), `surfaceColor` fill, `shadowLg`, and `24 dp` internal padding. It contains:
- A decorative centered SVG illustration (quiz-themed: speech bubbles with question marks, or a stylized quiz bowl trophy). This must be a vector asset, not a raster image.
- Heading: "Ready to Challenge Yourself?" in `headlineMedium`.
- Sub-copy: "10 random questions · Multiple categories · Track your best" in `bodyMedium`, `subtitleColor`.
- The primary Start button (full spec below).

**Stats Strip:** Three horizontally distributed `InfoChip` widgets below the hero card, each containing a small SVG icon and a label. The three chips display: "100 Questions", "10 Per Round", and "Mixed Categories". Chips use `surfaceColor`, `radiusSm`, `shadowSm`, and `labelMedium` text.

**Start Quiz Button:** Full-width, height **56 dp**, `radiusMd` (14 dp), `primaryColor` fill, white label "Start Quiz" in `buttonText`. On press, the button animates to 0.97 scale over 100 ms (press-down feel), then back to 1.0 over 80 ms before navigation begins. A centered ripple effect from `primaryColor` (lighter shade) emanates outward on press. Navigation uses a slide-up + fade-in transition to the Quiz screen.

**Best Score Badge:** If a previous best score is stored in `SharedPreferences`, a small pill badge appears in the top-right corner of the Hero Card reading "Best: X/10" with a small star icon. It uses `primaryColor` fill and `labelMedium` text. The badge animates in with a scale-from-zero pop (`Curves.elasticOut`, 400 ms) whenever the home screen is entered after a completed quiz.

**Card Entry Animation:** On first appearance, the Hero Card slides up from 40 dp below its final position and fades in over 400 ms using `Curves.easeOutBack`. The Stats Strip follows 80 ms later with the same animation.

---

### 3.3 Quiz Screen

This is the app's **core screen** and where the largest portion of UI/UX investment must be concentrated. Every interaction on this screen must feel instantaneous, smooth, and emotionally rewarding.

#### 3.3.1 Layout Architecture

The screen is a `Scaffold` with no `AppBar`. Instead, the top section is custom-built within the body. From top to bottom, the layout layers are:

**Layer 1 — Top Navigation Bar (custom):** Contains a back/exit `IconButton` (left-aligned, triggers quit confirmation modal) and the question counter "3 / 10" (right-aligned, `labelMedium`, `subtitleColor`). Height: 56 dp.

**Layer 2 — Progress Bar:** A full-width `LinearProgressIndicator`, height **4 dp**, `primaryColor` active color, `surfaceColor` background. It animates smoothly between question values over 400 ms using `Curves.easeInOut`. This sits directly below the navigation bar with no gap.

**Layer 3 — Category Chip:** A single pill badge centered horizontally, 8 dp below the progress bar, showing the current question's category (e.g., "🔬 Science"). Uses `primaryColor` fill at 20% opacity with `primaryColor` text and border.

**Layer 4 — Question Card:** The dominant element. A `Card` with `radiusLg`, `surfaceColor`, `shadowMd`, 24 dp internal padding, positioned 16 dp below the category chip. Question text uses `headlineMedium`. Minimum card height is 140 dp; text wraps naturally up to a maximum of 5 lines before the font size reduces to 18 sp.

**Layer 5 — Option Tiles:** Four `OptionTile` widgets stacked vertically with **12 dp** spacing between them, 24 dp below the question card. Each tile is `height: 60 dp`, `radiusMd`, `surfaceColor` fill, `shadowSm`, with the option text in `bodyLarge` left-aligned with 16 dp horizontal padding.

**Layer 6 — Bottom Action Area:** Fixed at the bottom with `24 dp + safe area` padding. Contains the Skip text button (pre-selection) or the Next/See Results button (post-selection). See Section 3.3.4.

#### 3.3.2 Option Tile State Machine

Each `OptionTile` implements a finite state machine with six states. The developer must implement this as a `StatefulWidget` with an explicit `OptionTileState` enum.

**Idle State:** `surfaceColor` background, `borderColor` border (1 dp), no icon, `onBackground` text. This is the default state when a question first loads.

**Pressed/Hover State:** Triggered on `onTapDown`. The tile scales to 0.97 over 80 ms and the background lightens to `surfaceVariant`. This state is brief — it resolves to either Selected or remains Idle if the tap is cancelled.

**Correct State:** Triggered 300 ms after the user taps the correct option. The background transitions to `successColor` (full opacity) via a `ColorTween` over 300 ms. A white check icon (`Icons.check_circle_rounded`) fades in from the right side of the tile over 200 ms. The tile scales up to 1.02 and back to 1.0 over 250 ms (`Curves.easeOut`).

**Incorrect State:** Triggered 300 ms after the user taps a wrong option. The background transitions to `accentColor` (full opacity). A white X icon (`Icons.cancel_rounded`) fades in. The tile executes a **shake animation**: translates horizontally `+6, −6, +5, −5, +3, −3, 0` dp over 400 ms using a custom `Tween<Offset>`. Frequency: approximately 3 cycles, decaying amplitude.

**Revealed State (Correct Answer Shown After Wrong Selection):** The tile containing the correct answer transitions to `successColor` at 60% opacity — visually distinct from the full-opacity Correct state — indicating "this was the right answer" without celebrating. All other incorrect tiles (not the user's selection) dim to 30% opacity.

**Disabled State:** All four tiles become non-tappable immediately after the user makes a selection. `AbsorbPointer` wraps the entire options column. The pointer cursor changes to forbidden on web/desktop. This state prevents double-tapping or accidental second selections.

#### 3.3.3 Question Transition Sequence

After the user selects an option, the following sequence fires on a single `AnimationController`:

At **0 ms**: Tiles enter their Correct, Incorrect, or Revealed states simultaneously.

At **900 ms**: The outgoing question card begins its exit — it slides left by 80 dp and fades to opacity 0 over **300 ms** using `Curves.easeInCubic`.

At **900 ms** (simultaneously): The incoming question card begins its entrance from the right — it starts 80 dp off-screen to the right and fades from opacity 0 — sliding to its final position over **300 ms** using `Curves.easeOutCubic`.

At **1050 ms** (staggered 150 ms after card entry begins): Option tiles fade in and slide up 12 dp, one at a time, with a **60 ms stagger** per tile. The first tile animates at 1050 ms, the fourth at 1230 ms.

At **1050 ms** (simultaneously): The progress bar animates to its new fill value over 400 ms.

The Category Chip cross-fades to the new question's category over 200 ms.

**Critical architectural note:** This entire sequence must be driven by a **single `AnimationController`** with multiple `CurvedAnimation` objects using `Interval` curves. Do not use `Future.delayed` chains or `Timer` to sequence animations — this creates race conditions and is impossible to test reliably.

#### 3.3.4 Bottom Action Area

**Before Selection (Skip Available):** A "Skip →" text button is right-aligned in `subtitleColor`, `labelMedium`. Tapping Skip records the question as unanswered (treated as incorrect for scoring) and immediately fires the next-question transition sequence. No confirmation is shown for Skip.

**After Selection (Next/Results):** The Skip button is replaced by a primary button reading "Next Question →" (or "See Results →" on question 10). This button pulses with a subtle scale animation (1.0 → 1.03 → 1.0, 1.2-second loop) to draw attention. The user can tap it to advance immediately, or it auto-fires after **1800 ms** from the moment the selection was made.

---

### 3.4 Results Screen

The results screen is the **emotional payoff** of the entire experience. It must delight the user regardless of their score, while clearly communicating their performance and offering an obvious, frictionless path to play again.

**Entry Transition:** A 200 ms flash to white (simulating a camera flash — a moment of "capture" for the achievement) followed by the screen content fading in from white to the dark background over 200 ms. This creates a satisfying punctuation between the quiz and the result.

**Score Circle:** A custom `CircularProgressPainter` widget, diameter **180 dp**, centered on screen. On entry, an arc animates from 0° to the user's score percentage (0–100%) over **1200 ms** using `Curves.easeOut`. The track (unfilled portion) is `surfaceColor`. The active arc color is dynamic:
- Score 0–4/10: `accentColor` (coral red)
- Score 5–7/10: `warningColor` (amber)
- Score 8–10/10: `successColor` (emerald)

At the center of the circle, the score animates as a counting number from 0 to the actual score over 1000 ms, displayed in `displayLarge` (Poppins Bold 48 sp), followed by `/ 10` in `titleMedium`, `subtitleColor`.

A `shadowLg` is applied to the circle container to create a glowing ring effect.

**Performance Label:** Dynamic text centered below the score circle. It appears with a scale-from-zero bounce (`Curves.elasticOut`, 500 ms) after the score circle animation completes:
- Score 0–3: "Keep Practicing! 💪" in `accentColor`
- Score 4–6: "Good Effort! 👏" in `warningColor`
- Score 7–8: "Well Done! ⭐" in `onBackground`
- Score 9–10: "Quiz Master! 🏆" in `successColor`

**Score Breakdown List:** A scrollable list below the performance label, showing all 10 questions. Each row contains: a green checkmark or red X icon (leading), the question text truncated to one line (body), and the correct answer in `successColor` on a second line. This gives the user educational value — they learn the right answer even for questions they got wrong.

The list animates in after the performance label, with each row sliding up and fading in with a 40 ms stagger per row.

**Action Buttons:** Two full-width buttons stacked with **12 dp** gap, pinned to the bottom of the screen with safe-area padding:
- **Primary:** "Play Again" — `primaryColor` fill, white text, `buttonText`, height 56 dp, `radiusMd`.
- **Secondary:** "Home" — transparent fill, `primaryColor` border (2 dp), `primaryColor` text, height 56 dp, `radiusMd`.

**Best Score Update Banner:** If the current score exceeds the stored best, a golden ribbon banner slides down from the top of the screen reading "🎉 New Personal Best!" in `warningColor`. It animates in after the score circle completes (using a slide-from-top + fade-in, 400 ms, `Curves.easeOutBack`) and auto-dismisses after 4 seconds.

**Confetti Effect (Scores 8–10):** Using the `confetti` Flutter package, a particle burst of `primaryColor` (#6C63FF) and `accentColor` (#FF6584) confetti rains from the top-center of the screen for **3 seconds** beginning when the score circle animation completes. The emitter position is at the top-center. Blast direction: downward hemisphere. The effect auto-stops and particles fall off-screen naturally.

---

## 4. Animation Specifications

Every animation listed in this section is a **product requirement**, not a suggestion. All 19 animations must be implemented and must achieve 60 fps in release mode before the feature is considered "done." The developer must run Flutter DevTools' Performance overlay during animation implementation and profile each animation on a physical mid-range Android device.

### 4.1 Complete Animation Inventory

| ID | Trigger | Animation Description | Duration | Easing Curve |
|---|---|---|---|---|
| AN-01 | App cold launch | Logo fade-in + scale from 0.8 to 1.0 | 600 ms | `Curves.elasticOut` |
| AN-02 | App name reveal | Per-character slide-up + fade-in, 30 ms stagger | ~500 ms total | `Curves.easeOutCubic` |
| AN-03 | Splash tagline | Full text fade-in | 300 ms | `Curves.easeIn` |
| AN-04 | Splash progress bar | Linear fill from 0% to 100% | 1800 ms | `Curves.linear` |
| AN-05 | Home screen entry | Hero card slide-up + fade-in from 40 dp below | 400 ms | `Curves.easeOutBack` |
| AN-06 | Stats strip entry | Same as AN-05, 80 ms delayed | 400 ms | `Curves.easeOutBack` |
| AN-07 | Start button press | Scale 1.0 → 0.97 → 1.0 on press | 180 ms total | `Curves.easeIn` / `easeOut` |
| AN-08 | Screen navigation | Custom slide-up + cross-fade page route | 350 ms | `Curves.easeInOut` |
| AN-09 | Question card entry | Slide from +80 dp right + fade-in | 300 ms | `Curves.easeOutCubic` |
| AN-10 | Option tile stagger | Slide up 12 dp + fade-in, 60 ms stagger per tile | ~300 ms total | `Curves.easeOutQuart` |
| AN-11 | Correct answer | Background `ColorTween` + scale 1.0→1.02→1.0 + icon pop | 350 ms | `Curves.easeOut` |
| AN-12 | Incorrect answer | Background `ColorTween` + shake ±6 dp × decaying 3 cycles | 400 ms | `Curves.elasticIn` |
| AN-13 | Revealed answer | Dim other tiles to 30% opacity, highlight correct to 60% | 300 ms | `Curves.easeOut` |
| AN-14 | Progress bar advance | Animated fill tween to new width | 400 ms | `Curves.easeInOut` |
| AN-15 | Question card exit | Slide left −80 dp + fade-out | 300 ms | `Curves.easeInCubic` |
| AN-16 | Timer bar (if used) | Continuous depletion; accelerates in last 5 s | 20000 ms | `Linear` → `Curves.easeIn` |
| AN-17 | Results flash entry | Screen flashes white, then fades to dark | 400 ms total | `Curves.easeIn` |
| AN-18 | Score circle fill | Arc from 0° to score%, number count up | 1200 ms | `Curves.easeOut` |
| AN-19 | Performance label | Scale from 0 with bounce overshoot | 500 ms | `Curves.elasticOut` |
| AN-20 | Score breakdown list | Per-row slide-up + fade-in, 40 ms stagger | ~600 ms total | `Curves.easeOutCubic` |
| AN-21 | Best score banner | Slide down from −60 dp + fade-in | 400 ms | `Curves.easeOutBack` |
| AN-22 | Confetti burst | Physics-based particle rain, 3 s duration | 3000 ms | Gravity physics |
| AN-23 | Play Again button idle | Subtle pulse scale 1.0→1.03→1.0 loop | 1500 ms loop | `Curves.easeInOut` |

### 4.2 Animation Architecture Rules

**Rule 1 — No orphaned `AnimationController`s:** Every `AnimationController` must be disposed in the `State.dispose()` method. The developer must use the `SingleTickerProviderStateMixin` or `TickerProviderStateMixin` for each widget that owns animations. Failing to dispose controllers causes memory leaks that are unacceptable in production.

**Rule 2 — Prefer implicit animations for simple transitions:** For single-property changes (color, opacity, size), use Flutter's implicit animation widgets (`AnimatedContainer`, `AnimatedOpacity`, `TweenAnimationBuilder`). Reserve explicit `AnimationController` usage for multi-step sequences, looping animations, and cases where precise timing control is required.

**Rule 3 — Sequence with `Interval`, not `Future.delayed`:** The question transition sequence (Section 3.3.3) must use a single `AnimationController` with multiple `CurvedAnimation` objects using `Interval(begin, end)` curves. This ensures the entire sequence can be paused, reversed, and tested as a unit.

**Rule 4 — Profile before shipping:** Use `flutter run --profile` on a physical device. Open Flutter DevTools and confirm the "UI" thread stays below 16 ms per frame for all animations. If any animation causes jank, reduce complexity rather than shipping jank.

**Rule 5 — Use `flutter_animate` for declarative chains:** The `flutter_animate` package (^4.3.0) is approved for use on the splash screen letter-by-letter animation and the score breakdown list stagger. It reduces boilerplate for sequential animations significantly.

---

## 5. Question Bank Architecture

### 5.1 Data Model

Every question in the bank conforms to the following Dart class. This is the single source of truth for the data model — the JSON schema, the Dart class, and the repository logic must all be consistent with this definition.

```dart
/// Represents a single quiz question with all metadata.
/// Immutable by design — questions are never mutated after loading.
@JsonSerializable()
class QuizQuestion {
  final String id;             // UUID v4 — unique across the entire bank
  final String question;       // The question text (max 200 characters)
  final List<String> options;  // Exactly 4 options — enforced by schema validation
  final int correctIndex;      // 0–3 — index into the options array
  final String category;       // e.g., "Science", "History" — from a fixed enum
  final Difficulty difficulty; // Enum: easy | medium | hard
  final String? explanation;   // Optional post-answer explanation (max 150 chars)

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.category,
    required this.difficulty,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}
```

The `difficulty` field uses a Dart enum with `@JsonValue` annotations for serialization. The `category` field is a freeform string in v1.0, but must be from a controlled vocabulary list (see Section 5.3) — this allows future filtering without a database migration.

### 5.2 Question Selection Algorithm

The `QuizRepository.getRandomSession()` method is the heart of the randomization system. It must implement the following exact logic:

**Step 1:** Access the pre-loaded in-memory question list (loaded during splash — see Section 3.1).

**Step 2:** Apply a **Fisher-Yates (Knuth) shuffle** to a copy of the full list. The algorithm must create a copy — never mutate the canonical in-memory bank.

```dart
/// Fisher-Yates shuffle — O(n) time, O(n) space (copy).
/// Guarantees every permutation is equally probable.
List<QuizQuestion> _shuffle(List<QuizQuestion> source) {
  final list = List<QuizQuestion>.from(source); // Always copy, never mutate
  final random = Random();
  for (int i = list.length - 1; i > 0; i--) {
    final j = random.nextInt(i + 1);
    final temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
  return list;
}
```

**Step 3:** Take the first 10 elements of the shuffled list.

**Step 4:** For each of the 10 selected questions, **independently shuffle the options array** and **recalculate `correctIndex`** to reflect the new order. This prevents the correct answer from always appearing at the same position (e.g., always the first option), which would create a learnable bias.

**Step 5:** Return an immutable `List<QuizQuestion>` (use `List.unmodifiable()`).

> ⚠️ **Anti-pattern warning:** Do NOT implement randomization as `Random.nextInt(100)` in a loop with duplicate checking. This approach has non-uniform distribution characteristics and O(n²) worst-case time. Fisher-Yates is the correct algorithm.

### 5.3 Question Categories & Distribution

The 100 questions are distributed across 8 categories. This distribution ensures that a 10-question random sample almost always includes multiple categories, creating variety in every session.

| Category | Count | Difficulty Mix | Topic Areas |
|---|---|---|---|
| Science & Nature | 15 | 5 easy / 6 medium / 4 hard | Physics, chemistry, biology, space, earth science |
| History & Geography | 15 | 5 easy / 6 medium / 4 hard | World history, capitals, landmarks, world wars |
| Technology & Computing | 15 | 4 easy / 7 medium / 4 hard | CS fundamentals, internet history, gadgets, coding |
| Pop Culture | 15 | 8 easy / 5 medium / 2 hard | Movies, music, TV shows, sports, celebrities |
| Language & Literature | 15 | 5 easy / 6 medium / 4 hard | Vocabulary, famous authors, quotes, grammar |
| Mathematics | 10 | 3 easy / 4 medium / 3 hard | Arithmetic, geometry, algebra, logic puzzles |
| Food & Culture | 10 | 5 easy / 4 medium / 1 hard | World cuisine, traditions, national symbols |
| Sports & Fitness | 5 | 3 easy / 2 medium / 0 hard | Rules, records, famous athletes, Olympics |
| **TOTAL** | **100** | **38 easy / 40 medium / 22 hard** | |

### 5.4 Sample Questions from the Bank

The following 10 questions illustrate the expected format, tone, and style of the question bank. The content team must deliver all 100 questions in this format, validated against the JSON schema, before engineering begins.

| # | Question | Correct Answer | Category | Difficulty |
|---|---|---|---|---|
| Q01 | What is the powerhouse of the cell? | Mitochondria | Science | Easy |
| Q02 | In what year did World War II end? | 1945 | History | Easy |
| Q03 | Which programming language does Flutter use? | Dart | Technology | Easy |
| Q04 | Who painted the Mona Lisa? | Leonardo da Vinci | Pop Culture | Easy |
| Q05 | What is the square root of 144? | 12 | Mathematics | Easy |
| Q06 | Which country has the largest land area? | Russia | Geography | Easy |
| Q07 | What does HTTP stand for? | HyperText Transfer Protocol | Technology | Medium |
| Q08 | Which planet has the most confirmed moons? | Saturn | Science | Medium |
| Q09 | In Shakespeare's Hamlet, who is Hamlet's father? | King Hamlet (the ghost) | Literature | Medium |
| Q10 | What sorting algorithm has the best average-case time complexity? | Merge Sort / Quick Sort | Technology | Hard |

### 5.5 JSON Asset Format

The question bank is stored at `assets/data/questions.json`. The file must conform to this schema:

```json
{
  "version": "1.0.0",
  "count": 100,
  "questions": [
    {
      "id": "q_uuid_v4_here",
      "question": "What is the powerhouse of the cell?",
      "options": ["Nucleus", "Mitochondria", "Ribosome", "Golgi Apparatus"],
      "correctIndex": 1,
      "category": "Science",
      "difficulty": "easy",
      "explanation": "Mitochondria generate most of the cell's ATP through cellular respiration."
    }
  ]
}
```

A JSON Schema validation script must be committed to the repository (`scripts/validate_questions.dart`) and run as a pre-commit hook. It must verify: the count is exactly 100, every question has exactly 4 options, `correctIndex` is 0–3, all required fields are present, and no two questions share the same `id`.

---

## 6. User Stories & Acceptance Criteria

Each user story is prioritized with a **P0** (launch blocker), **P1** (launch target), or **P2** (nice-to-have, defer if needed) label.

| ID | As a... | I want to... | Acceptance Criteria | Priority |
|---|---|---|---|---|
| US-01 | User | See an animated splash screen on launch | Splash appears within 100 ms of cold launch; all animations play; auto-transitions to home in ≤ 2.2 s; no dropped frames | P0 |
| US-02 | User | Start a new quiz with one tap | A single "Start Quiz" tap begins a session; first question is displayed within 300 ms of tap | P0 |
| US-03 | User | Answer questions by tapping an option | Tapping disables all tiles immediately; correct/wrong state shown within 300 ms of tap | P0 |
| US-04 | User | See the correct answer when I answer wrong | After wrong selection, the correct option highlights in successColor before advancing | P0 |
| US-05 | User | Track my progress through the quiz | Progress bar and "X / 10" counter are always visible and animate correctly after each question | P0 |
| US-06 | User | See my final score at the end | Results screen shows animated score circle, numeric score, performance label, and full question breakdown | P0 |
| US-07 | User | Replay with fresh random questions | "Play Again" starts a new session with a new Fisher-Yates draw; questions are statistically unlikely to be identical | P0 |
| US-08 | User | Return to home from results | "Home" button navigates back with smooth transition; home screen updates to show new best score if applicable | P0 |
| US-09 | User | Skip a question I don't know | "Skip" is available before selection; skipped questions count as incorrect; no confirmation dialog | P1 |
| US-10 | User | See my all-time best score | Best score persisted in SharedPreferences, shown on home screen and results, updates when beaten | P1 |
| US-11 | User | See a celebration for a high score | Scores 8–10 trigger confetti animation for 3 s; scores 9–10 also trigger "New Personal Best" banner if applicable | P1 |
| US-12 | User | Experience smooth 60 fps animations | All transitions and animations confirmed at 60 fps on a mid-range 2019 Android device in release mode | P0 |
| US-13 | User | Know which category each question belongs to | A category chip is visible above the question text and updates with each question | P1 |
| US-14 | User | Quit mid-quiz safely | Pressing back during quiz shows a bottom sheet confirmation with "Quit" and "Keep Playing" options | P1 |
| US-15 | User | See a question explanation after answering | If an explanation is present in the data, it displays below the revealed answer state for 1.2 s before auto-advance | P2 |

---

## 7. State Management & App Architecture

### 7.1 Required State Management Solution

The app must use **Riverpod** (package: `flutter_riverpod` ^2.4.0) as its state management solution. `setState()` is permitted only for purely local, self-contained widget-level states (e.g., a button press animation scale). All application state — quiz session state, score history, navigation-affecting logic — must live in Riverpod `StateNotifier` or `AsyncNotifier` providers.

The developer must not use `Provider` (the original package), `BLoC`, `GetX`, or `ChangeNotifier` directly. Riverpod is the only approved solution for this project because of its compile-time safety, testability, and compatibility with the clean architecture described below.

### 7.2 Clean Architecture Layer Breakdown

The project structure follows a clean architecture pattern adapted for Flutter. The folder structure mirrors the architectural layers:

```
lib/
├── core/
│   ├── theme/          # app_theme.dart — all colors, typography, shadows
│   ├── router/         # app_router.dart — go_router configuration
│   └── constants/      # app_constants.dart — timing values, string keys
├── domain/
│   └── models/         # QuizQuestion, QuizSession, QuizResult, Difficulty
├── data/
│   ├── datasources/    # LocalJsonDataSource, LocalStorageDataSource
│   └── repositories/   # QuizRepository (interface + implementation)
├── features/
│   ├── splash/
│   │   └── views/      # SplashScreen widget
│   ├── home/
│   │   ├── views/      # HomeScreen widget
│   │   └── providers/  # HomeNotifier (reads best score)
│   ├── quiz/
│   │   ├── views/      # QuizScreen, OptionTile, QuestionCard, ProgressHeader
│   │   └── providers/  # QuizSessionNotifier
│   └── results/
│       ├── views/      # ResultsScreen, ScoreCircle, BreakdownList
│       └── providers/  # ResultsNotifier (reads session result)
└── main.dart           # ProviderScope wraps MaterialApp
```

**Layer responsibilities are strict:** Widgets (views) only read from providers — they contain zero business logic. Providers (notifiers) handle events and call repositories — they contain zero Flutter imports. Repositories abstract data sources — they contain zero UI logic. Data sources interact with the file system or storage — they contain zero business logic.

### 7.3 Quiz Session State Model

The `QuizSessionNotifier` holds the following `QuizSessionState`:

```dart
@freezed
class QuizSessionState with _$QuizSessionState {
  const factory QuizSessionState({
    @Default([]) List<QuizQuestion> questions,
    @Default(0) int currentIndex,
    @Default({}) Map<int, int?> selectedAnswers, // question index → option index (null = skipped)
    @Default(QuizStatus.notStarted) QuizStatus status,
  }) = _QuizSessionState;

  // Computed getter — not stored state
  // Score = count of indices where selectedAnswers[i] == questions[i].correctIndex
}

enum QuizStatus { notStarted, inProgress, awaitingNextQuestion, completed }
```

The `awaitingNextQuestion` status is crucial — it represents the 900 ms window after an answer is selected but before the next question loads. During this window, all tiles are disabled and the reveal animation plays. The UI must respond to this state to prevent user interaction.

### 7.4 Navigation (Routing)

The app uses **`go_router`** (^13.0.0) for declarative routing. The route map is:

```
/ (splash)  →  /home  →  /quiz  →  /results
```

The `/quiz` route accepts no URL parameters — the quiz session is managed entirely in Riverpod state, not in the route. The `/results` route similarly reads from state, not from route parameters. This prevents state loss on deep links and makes the app resistant to back-navigation abuse.

Navigation guards must prevent the user from navigating directly to `/quiz` or `/results` if no active session exists — they must redirect to `/home`.

### 7.5 Local Persistence

`SharedPreferences` is used exclusively for storing the best score. The storage contract is:

| Key | Type | Default | Read Location | Write Location |
|---|---|---|---|---|
| `best_score` | `int` | `0` | `HomeNotifier.init()` | `QuizSessionNotifier.completeSession()` |

Write occurs inside `completeSession()` only when the new score strictly exceeds the stored value. Reads happen once when the home screen initializes. The `LocalStorageDataSource` class wraps all `SharedPreferences` calls so they can be mocked in tests.

---

## 8. Technical Specifications & Package List

### 8.1 SDK & Platform Requirements

| Requirement | Specification |
|---|---|
| Flutter SDK | ≥ 3.19.0 (stable channel) |
| Dart SDK | ≥ 3.3.0 |
| Minimum Android SDK | API 21 (Android 5.0 Lollipop) |
| Target Android SDK | API 34 (Android 14) |
| Minimum iOS | iOS 13.0 |
| Target iOS | iOS 17.0 |
| Build flavor | release mode for all performance testing |

### 8.2 Required Packages

The following packages are approved and required. The developer must not introduce additional dependencies without written approval from the product owner (to keep the bundle size under control).

| Package | Version | Purpose |
|---|---|---|
| `flutter_riverpod` | ^2.4.0 | State management — the required architecture choice |
| `riverpod_annotation` | ^2.3.3 | Code-gen annotations for Riverpod providers |
| `google_fonts` | ^6.1.0 | Poppins and Inter typefaces |
| `shared_preferences` | ^2.2.2 | Best score local persistence |
| `confetti` | ^0.7.0 | Particle confetti effect on high scores |
| `flutter_animate` | ^4.3.0 | Declarative animation chains (splash, breakdown list) |
| `go_router` | ^13.0.0 | Declarative routing with navigation guards |
| `json_annotation` | ^4.8.1 | `@JsonSerializable` for `QuizQuestion.fromJson` |
| `freezed_annotation` | ^2.4.1 | Immutable state classes for Riverpod notifiers |
| `build_runner` | ^2.4.7 | *dev* — runs `json_serializable`, `freezed`, `riverpod_generator` |
| `json_serializable` | ^6.7.1 | *dev* — generates `fromJson`/`toJson` |
| `freezed` | ^2.4.6 | *dev* — generates immutable state class internals |
| `flutter_test` | SDK | *dev* — unit and widget tests |
| `mocktail` | ^1.0.0 | *dev* — mock objects for testing repositories |

### 8.3 Performance Targets

These are hard targets, not aspirational goals. A feature fails QA if any target is missed.

| Metric | Target | Measurement Method |
|---|---|---|
| Cold start → splash visible | < 800 ms | Flutter DevTools Timeline |
| Splash → home transition | ≤ 2.2 s total | Stopwatch + DevTools |
| Frame rate during all animations | 60 fps (≥ 58 fps acceptable) | DevTools Performance overlay on physical device |
| Tap → answer state visible | < 100 ms | DevTools event latency |
| Question bank JSON load time | < 50 ms | Dart `Stopwatch` in debug mode |
| Release APK size | < 25 MB | `flutter build apk --release` |
| App RAM usage during quiz | < 120 MB | Android Profiler |

### 8.4 Build & Release Configuration

The app must support both `debug` and `release` build flavors. The `--profile` flag is used for animation performance testing on physical devices. Obfuscation (`--obfuscate --split-debug-info`) must be applied for release builds. A `Makefile` or shell script must be included in the repository for common tasks: `make run`, `make test`, `make build-android`, `make build-ios`.

---

## 9. End-to-End User Flow

### 9.1 The Complete Journey

The following table describes every step of the end-to-end user loop from cold launch to quiz reset. The developer must implement every step exactly as specified. The "System Response" column defines what the app must do — not suggestions.

| Step | Screen | User Action | System Response |
|---|---|---|---|
| 1 | Splash | Opens app (cold start) | Logo + name animation plays; question JSON pre-loads into memory; progress bar fills |
| 2 | Splash | Waits | After 2.2 s max, cross-fades to Home screen |
| 3 | Home | Views home screen | Hero card slides up; stats strip appears; best score badge shows if score exists |
| 4 | Home | Taps "Start Quiz" | Button press animation; Fisher-Yates draw of 10 questions; slide-up to Quiz screen Q1 |
| 5 | Quiz Q1 | Reads question, taps an option tile | Tile disables all options; 300 ms later shows Correct/Incorrect state |
| 6 | Quiz Q1 | Sees result state | After 900 ms, transition animation fires; Q2 slides in with staggered options |
| 7 | Quiz Q2–Q9 | Repeats step 5–6 | Progress bar advances; counter increments; each question enters via slide animation |
| 8 | Quiz Q10 | Answers final question | "Next Question" button changes label to "See Results →" |
| 9 | Quiz Q10 | Taps "See Results" (or auto-advances) | Flash transition to Results screen |
| 10 | Results | Views score | Score circle fills; number counts up; performance label bounces in; breakdown list staggers in |
| 11 | Results | Score ≥ 8 | Confetti rains for 3 s |
| 12 | Results | New best score | Golden "New Personal Best!" banner slides down; SharedPreferences updated |
| 13A | Results | Taps "Play Again" | New 10-question draw; slide transition to Quiz Q1 (no home screen in between) |
| 13B | Results | Taps "Home" | Slide transition back to home; best score badge updates if new best was set |

### 9.2 Edge Cases

Every edge case listed here must be handled and must have a corresponding test case (unit or widget).

**Quiz quit mid-session:** When the user presses the Android hardware back button or iOS swipe-back gesture during an active quiz, a `ModalBottomSheet` appears from the bottom with the title "Quit Quiz?" and body copy "Your current progress will be lost." and two buttons: "Keep Playing" (primary) and "Quit" (text, `accentColor`). The sheet has `radiusXl` top corners and `surfaceColor` background. Tapping "Quit" calls `QuizSessionNotifier.abandonSession()` and navigates to Home.

**JSON load failure:** If `assets/data/questions.json` cannot be parsed (corrupt asset, unexpected schema), the splash screen must not crash. Instead, it navigates to a dedicated `ErrorScreen` displaying "Something went wrong loading the question bank." with a "Retry" button that re-attempts the load. This scenario must be covered by a unit test with a mock data source.

**Fewer than 10 questions available:** This should not occur in v1.0 (the bank always has 100), but the algorithm must handle it gracefully: if `filteredList.length < 10`, use all available questions and update the session counter display accordingly.

**SharedPreferences write failure:** If the best score write fails (storage full, permissions revoked), fail silently and log the error to the debug console. Do not show an error dialog for a non-critical persistence failure.

**Rapid tapping during transition:** During the 900 ms reveal window and the subsequent transition animation, all option tiles must be wrapped in `AbsorbPointer(absorbing: status == QuizStatus.awaitingNextQuestion)`. This is enforced at the parent level, not on individual tiles, to ensure no tap can slip through.

---

## 10. Testing Requirements

### 10.1 Unit Tests

The following logic must have 100% unit test coverage. All unit tests live in `test/unit/`.

**`QuizRepository` tests:**
The `getRandomSession()` method must be called 1000 times in a test loop. Each call is verified to return exactly 10 questions, all sourced from the 100-question bank, with no duplicates within a single session. The test also verifies that `correctIndex` is valid (0–3) after options are shuffled.

**Fisher-Yates shuffle tests:**
The `_shuffle` method must be tested to confirm it returns a list with the same elements as input (no additions or removals), and that the output order is different from the input order in a statistically significant proportion of runs (>95% of 100 trials).

**`QuizSessionNotifier` state transition tests:**
Every valid state transition must be tested: `notStarted → inProgress`, `inProgress → awaitingNextQuestion`, `awaitingNextQuestion → inProgress`, `inProgress → awaitingNextQuestion → completed`. Invalid transitions (e.g., completing from `notStarted`) must be tested to confirm they are no-ops.

**Score calculation tests:**
The score computed property must be verified for all boundary cases: all correct (10), all wrong (0), all skipped (0), mixed correct/wrong/skipped.

**`LocalStorageDataSource` tests:**
Using `mocktail`, mock `SharedPreferences` and verify that `saveBestScore()` writes the correct key/value and that `getBestScore()` returns 0 if no value is stored.

### 10.2 Widget Tests

Widget tests live in `test/widget/`. They must use `ProviderScope` with overridden mock providers.

The `OptionTile` widget must be tested for all six visual states (idle, pressed, correct, incorrect, revealed, disabled) by pumping the widget with each state and verifying the correct color, icon, and pointer behavior.

The `QuizProgressBar` widget must be tested to confirm it renders at the correct fractional width for values 0/10 through 10/10 and that the animation completes without exceptions.

The `ResultsScreen` must be tested for all four score tier labels (0–3, 4–6, 7–8, 9–10) by overriding the results provider with a mock and verifying the label text and score circle color.

### 10.3 Integration Tests

Integration tests live in `integration_test/` using the `flutter_test` integration_test package with a real device or emulator.

**Full quiz loop test:** Launch the app, wait for the home screen, tap "Start Quiz", answer all 10 questions (tap the first option each time), verify the results screen appears with a valid score display.

**Play Again flow test:** Complete the above, tap "Play Again", verify that a new quiz starts and that at least one question in the new set is statistically likely to differ (run 3 iterations and verify not all sets are identical).

**Best score persistence test:** Complete a quiz scoring 7. Restart the app (hot restart in test). Verify the home screen shows "Best: 7/10".

### 10.4 Manual QA Checklist

Before every release candidate, a human must manually verify the following on **both** a physical iOS device (iPhone with iOS 16+) and a physical Android device (mid-range, Android 10+):

Every animation in the AN-01 through AN-23 inventory plays at visibly smooth frame rate with no jank, stutter, or layout shift. Confetti appears for scores 8, 9, and 10 only. The quit confirmation sheet appears on back gesture during a quiz. The app functions correctly with no internet connection (fully offline). Questions do not repeat within a single 10-question session. Best score updates correctly after a new personal best is achieved.

---

## 11. Accessibility & Localization

### 11.1 Accessibility Requirements

**Touch targets:** Every tappable element must have a minimum touch target of **48 × 48 dp** as per Material Design guidelines. This applies to the Skip text button, the category chip, and all icon buttons. Use `GestureDetector` with `behavior: HitTestBehavior.opaque` or increase the widget size with transparent padding where necessary.

**Contrast ratios:** All text must meet WCAG AA contrast ratios. The developer must verify the following pairs using a contrast checker tool before shipping:
- `onBackground` (#F0EEFF) on `backgroundColor` (#1A1A2E) — target: >10:1
- `subtitleColor` (#9CA3AF) on `surfaceColor` (#2D2D44) — target: >4.5:1
- White text on `primaryColor` (#6C63FF) — target: >3.0:1 (for large text at 16+ sp)

**Semantic labels:** Every icon-only widget must be wrapped in `Semantics(label: "...")`. Specifically: the exit/quit icon button ("Exit quiz"), the skip button ("Skip question"), the check icon on correct tiles ("Correct answer"), and the X icon on incorrect tiles ("Incorrect answer").

**Score circle:** The score circle widget must include `Semantics(label: "Your score is X out of 10")` so screen readers announce the result meaningfully rather than reading raw numbers.

**Option tiles:** Each `OptionTile` must set `Semantics(selected: isSelected, label: optionText)` so VoiceOver and TalkBack can communicate selection state to visually impaired users.

**Reduced motion:** The app must check `MediaQuery.of(context).disableAnimations`. If true, all animation durations must collapse to 1 ms (effectively instant). Implement this as a global `AnimationDurationMultiplier` constant read once in `main.dart`.

### 11.2 Localization Architecture

Version 1.0 ships in **English only**. However, the app must be localization-ready from day one. All user-facing strings must be defined in `lib/l10n/app_en.arb` and accessed via `AppLocalizations.of(context).stringKey`. Hard-coding strings inside widget `build()` methods is not permitted.

The ARB file must include all strings used in the app: screen titles, button labels, error messages, performance labels, and confirmation dialog copy. This preparation means adding a new language in v1.1 requires only a new ARB file — zero code changes.

---

## 12. Delivery Milestones & Definition of Done

### 12.1 Sprint Plan

The project is structured as five one-week sprints. The timeline assumes a single full-stack Flutter developer. Each sprint has a clear, verifiable deliverable.

| Sprint | Name | Deliverables | Exit Criteria |
|---|---|---|---|
| S1 | Foundation | Project setup, folder structure, `app_theme.dart` with all tokens, `go_router` skeleton, 100-question JSON asset, schema validation script | Theme renders correctly on device; routing navigates between placeholder screens; JSON validates |
| S2 | Core Logic | `QuizQuestion` model, `QuizRepository` with Fisher-Yates, `QuizSessionNotifier`, `LocalStorageDataSource`, all unit tests passing | 100% unit test pass rate; `getRandomSession()` returns correct output in 1000-iteration test |
| S3 | Screen Shells | All four screens built with static data (no animations): Splash, Home, Quiz, Results; full routing connected | Full loop navigable on physical device with no crashes; all UI elements present and correctly styled |
| S4 | Animations | All 23 animations from Section 4 implemented; profiled at ≥ 58 fps on physical Android mid-range device in release mode | DevTools confirms frame rate target; all animations match timing/easing specs |
| S5 | Polish & Ship | Accessibility audit, all widget and integration tests passing, manual QA checklist complete, app store assets, release build signed | Zero P0 bugs; all QA checklist items checked; APK < 25 MB |

### 12.2 Definition of Done

A user story or feature is considered **done** — and only done — when all six of the following criteria are satisfied simultaneously:

**Criterion 1 — Specification Match:** The implemented feature matches every detail of its specification in this document without deviation or creative interpretation. If a specification is ambiguous, the developer raises a question before implementing, not after.

**Criterion 2 — Tests Pass:** All relevant unit tests, widget tests, and integration tests pass in CI (GitHub Actions or equivalent). No test may be skipped or marked as pending at the time of merging.

**Criterion 3 — Performance Verified:** For any feature that involves animation or screen transition, the developer must attach a screenshot of Flutter DevTools' Performance overlay showing ≥ 58 fps on a physical device in release mode to the pull request.

**Criterion 4 — Accessibility Compliant:** The feature's touch targets are ≥ 48 dp, all semantic labels are in place, and contrast ratios are verified.

**Criterion 5 — Localized:** All new strings introduced by the feature are in `app_en.arb`. Zero hard-coded strings remain in the widget tree.

**Criterion 6 — Peer Reviewed:** The code has been reviewed and approved by at least one other developer before merging. The review must explicitly check for disposed `AnimationController`s, absent `setState()` calls in business logic, and correct layer separation.

---

## Appendix A — Quick Reference Card for Developers

This appendix summarizes the most frequently referenced values so developers don't need to search the full document during implementation.

**The core timing constants** that appear most frequently: option reveal delay is **900 ms**, question transition is **300 ms**, progress bar animation is **400 ms**, auto-advance delay is **1800 ms**, score circle fill is **1200 ms**.

**The three most critical architecture rules** to remember every day: (1) Never `setState()` for application state — use Riverpod. (2) Never dispose-less `AnimationController` — always in `dispose()`. (3) Never hard-code colors or strings — always use `AppTheme` tokens and `AppLocalizations`.

**The correct import for theme tokens** in any widget file is `import 'package:quiz_master/core/theme/app_theme.dart';`. This file is the single source of truth and must be the only place where hex color values appear in the entire codebase.

---

*End of Document — QuizMaster Pro PRD v1.0*  
*For clarifications, contact the Product Team. This document supersedes all prior versions and informal specifications.*
