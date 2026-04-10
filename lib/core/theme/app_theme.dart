import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme - Single source of truth for all design tokens per PRD §2
/// Never use hardcoded colors, fonts, or spacing values in widgets.
/// Always reference these tokens via AppColors, AppTypography, AppSpacing, etc.

class AppColors {
  AppColors._(); // Prevent instantiation

  // Primary brand color - used for CTAs, active states, progress
  static const Color primaryColor = Color(0xFF6C63FF);

  // Accent/emotional highlight - incorrect answers, warnings
  static const Color accentColor = Color(0xFFFF6584);

  // Dark base - scaffold background
  static const Color backgroundColor = Color(0xFF1A1A2E);

  // Card and tile backgrounds
  static const Color surfaceColor = Color(0xFF2D2D44);

  // Elevated surfaces - modals, overlays
  static const Color surfaceVariant = Color(0xFF363656);

  // Success state - correct answers, high scores
  static const Color successColor = Color(0xFF10B981);

  // Warning state - mid performance, timer urgency
  static const Color warningColor = Color(0xFFF59E0B);

  // Primary text on dark surfaces
  static const Color onBackground = Color(0xFFF0EEFF);

  // Secondary text - hints, metadata, captions
  static const Color subtitleColor = Color(0xFF9CA3AF);

  // Subtle dividers - tile borders, section separators
  static const Color borderColor = Color(0xFF3F3F60);
}

class AppTypography {
  AppTypography._();

  /// Display Large - Score result number (Poppins Bold 700, 48sp, -0.5 letter spacing)
  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
      color: AppColors.onBackground,
    );
  }

  /// Headline Large - Screen titles, splash headline (Poppins SemiBold 600, 28sp, -0.3 letter spacing)
  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: AppColors.onBackground,
    );
  }

  /// Headline Medium - Question text on card (Poppins SemiBold 600, 22sp, -0.2 letter spacing)
  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: AppColors.onBackground,
    );
  }

  /// Title Medium - Card sub-headers, result labels (Poppins Medium 500, 18sp, 0 letter spacing)
  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.onBackground,
    );
  }

  /// Body Large - Option text, body copy (Inter Regular 400, 16sp, 0 letter spacing)
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.onBackground,
    );
  }

  /// Body Medium - Supporting descriptions (Inter Regular 400, 14sp, 0.1 letter spacing)
  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: AppColors.onBackground,
    );
  }

  /// Label Medium - Category chip, metadata (Inter Medium 500, 13sp, 0.2 letter spacing)
  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: AppColors.onBackground,
    );
  }

  /// Button Text - All CTA button labels (Poppins Bold 700, 16sp, 0.5 letter spacing)
  static TextStyle buttonText(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      color: AppColors.onBackground,
    );
  }
}

class AppSpacing {
  AppSpacing._();

  // 8-point grid values (per PRD §2.4)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;
  static const double extreme = 56.0;
  static const double monumental = 64.0;
  static const double astronomical = 80.0;
  static const double cosmic = 96.0;

  // Horizontal content padding (PRD §2.4)
  static const double horizontalPadding = xxl; // 24 dp

  // Safe-area-aware bottom padding
  static double safeAreaBottomPadding(BuildContext context) {
    return xxl + MediaQuery.of(context).padding.bottom;
  }
}

class AppRadius {
  AppRadius._();

  // Border radius scale per PRD §2.6
  static const double xs = 8.0; // Chips, small badges
  static const double sm = 12.0; // Input fields, small buttons
  static const double md = 14.0; // Option tiles, standard buttons
  static const double lg = 20.0; // Question cards, hero cards
  static const double xl = 28.0; // Bottom sheets, modals
  static const double full = 999.0; // Circular elements, pill badges

  static BorderRadius radiusXs() => BorderRadius.circular(xs);
  static BorderRadius radiusSm() => BorderRadius.circular(sm);
  static BorderRadius radiusMd() => BorderRadius.circular(md);
  static BorderRadius radiusLg() => BorderRadius.circular(lg);
  static BorderRadius radiusXl() => BorderRadius.circular(xl);
  static BorderRadius radiusFull() => BorderRadius.circular(full);
}

class AppShadows {
  AppShadows._();

  // Shadow system: uses primaryColor with varying opacity for "glow" effect on dark surfaces
  // Avoid using Material elevation system; use explicit BoxShadow definitions.

  /// Small shadow - idle option tiles, small chips
  static const BoxShadow shadowSm = BoxShadow(
    offset: Offset(0, 4),
    blurRadius: 12,
    color: Color(0x336C63FF), // primaryColor with 0x33 alpha (~20%)
  );

  /// Medium shadow - question cards, home hero card
  static const BoxShadow shadowMd = BoxShadow(
    offset: Offset(0, 8),
    blurRadius: 24,
    color: Color(0x4D6C63FF), // primaryColor with 0x4D alpha (~30%)
  );

  /// Large shadow - modals, result cards, score circle
  static const BoxShadow shadowLg = BoxShadow(
    offset: Offset(0, 16),
    blurRadius: 40,
    color: Color(0x666C63FF), // primaryColor with 0x66 alpha (~40%)
  );

  // Convenience lists for multiple shadows
  static const List<BoxShadow> elevationSm = [shadowSm];
  static const List<BoxShadow> elevationMd = [shadowMd];
  static const List<BoxShadow> elevationLg = [shadowLg];
}

/// ThemeData for Material App
class AppThemeData {
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      secondaryHeaderColor: AppColors.accentColor,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryColor,
        secondary: AppColors.accentColor,
        surface: AppColors.surfaceColor,
        background: AppColors.backgroundColor,
        onBackground: AppColors.onBackground,
        onSurface: AppColors.onBackground,
        error: AppColors.accentColor,
        tertiary: AppColors.warningColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceColor,
        foregroundColor: AppColors.onBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.onBackground,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.radiusMd(),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: AppColors.onBackground,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: AppColors.onBackground,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: AppColors.onBackground,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: AppColors.onBackground,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: AppColors.onBackground,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: AppColors.onBackground,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: AppColors.onBackground,
        ),
      ),
    );
  }
}
