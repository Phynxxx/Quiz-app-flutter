/// AppConstants - Application-wide constants per PRD requirements

class AppConstants {
  AppConstants._(); // Prevent instantiation

  /// Number of questions presented per quiz session (PRD §1.2)
  static const int questionsPerQuiz = 10;

  /// Total questions in the question bank (PRD §1.2)
  static const int totalQuestionsInBank = 100;

  /// Score threshold for passing (50% pass threshold)
  /// If questionsPerQuiz = 10 and each correct answer = 10 points,
  /// a score of 50 or more (5 out of 10 correct) passes
  static const int passThreshold = 50;

  /// Maximum score possible per quiz (questionsPerQuiz * 10)
  static const int maxScorePossible = questionsPerQuiz * 10;

  /// Splash screen display duration in seconds
  static const int splashScreenDurationSeconds = 2;

  /// Animation durations (in milliseconds)
  static const int fadeInDurationMs = 200;
  static const int slideUpDurationMs = 300;
  static const int scaleTapDurationMs = 100;

  /// Per-question timer duration in seconds
  static const int questionTimerSeconds = 30;

  /// Auto-show hint after this many seconds of no interaction
  static const int hintAutoRevealSeconds = 15;

  /// Total hints allowed in a single quiz session
  static const int totalHintsPerQuiz = 3;
}
