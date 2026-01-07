import 'package:flutter/material.dart';
import 'package:line_a_day/features/settings/domain/model/theme_model.dart';

class AppTheme {
  // 동적 색상 (ColorTheme에 따라 변경)
  static Color primaryBlue = const Color(0xFF3B82F6);
  static Color primaryPurple = const Color(0xFF8B5CF6);

  // 그라데이션
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    colors: [Color(0xFFEFF6FF), Color(0xFFE0E7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Mode 중립 색상
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray600 = Color(0xFF6B7280);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);

  // Dark Mode 중립 색상
  static const darkGray900 = Color(0xFF0F172A);
  static const darkGray800 = Color(0xFF1E293B);
  static const darkGray700 = Color(0xFF334155);
  static const darkGray600 = Color(0xFF475569);
  static const darkGray500 = Color(0xFF64748B);
  static const darkGray400 = Color(0xFF94A3B8);
  static const darkGray300 = Color(0xFFCBD5E1);
  static const darkGray200 = Color(0xFFE2E8F0);

  // 상태 색상
  static const successGreen = Color(0xFF10B981);
  static const errorRed = Color(0xFFEF4444);
  static const warningYellow = Color(0xFFF59E0B);

  // 텍스트 스타일 (Light Mode)
  static const displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: gray900,
    height: 1.2,
  );

  static const displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: gray900,
    height: 1.2,
  );

  static const headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: gray800,
    height: 1.3,
  );

  static const headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: gray700,
    height: 1.4,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: gray700,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: gray700,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: gray600,
    height: 1.5,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: gray700,
    height: 1.4,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: gray600,
    height: 1.4,
  );

  // 그림자
  static final cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // Border Radius
  static const radiusSmall = 8.0;
  static const radiusMedium = 12.0;
  static const radiusLarge = 16.0;
  static const radiusXLarge = 20.0;
  static const radiusFull = 999.0;

  // Spacing
  static const spaceXSmall = 4.0;
  static const spaceSmall = 8.0;
  static const spaceMedium = 16.0;
  static const spaceLarge = 24.0;
  static const spaceXLarge = 32.0;

  // 색상 테마 업데이트
  static void updateColorTheme(AppColorTheme colorTheme) {
    primaryBlue = colorTheme.primaryColor;
    primaryPurple = colorTheme.secondaryColor;
    primaryGradient = colorTheme.gradient;
  }

  // Light Theme 생성
  static ThemeData lightTheme(AppColorTheme colorTheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // 색상 스키마
      colorScheme: ColorScheme.light(
        primary: colorTheme.primaryColor,
        secondary: colorTheme.secondaryColor,
        surface: Colors.white,
        surfaceContainerHighest: gray100,
        onSurface: gray900,
        onSurfaceVariant: gray600,
        error: errorRed,
        onError: Colors.white,
        outline: gray300,
        outlineVariant: gray200,
      ),

      scaffoldBackgroundColor: gray50,
      fontFamily: 'Pretendard',

      // 앱바 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: titleLarge,
        iconTheme: IconThemeData(color: gray600),
        surfaceTintColor: Colors.transparent,
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
        shadowColor: Colors.black.withOpacity(0.08),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: colorTheme.primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          textStyle: titleMedium.copyWith(color: Colors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorTheme.primaryColor,
          side: BorderSide(color: colorTheme.primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: gray200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.all(spaceMedium),
        hintStyle: bodyMedium.copyWith(color: gray400),
      ),

      // 스위치 테마
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorTheme.primaryColor;
          }
          return gray400;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorTheme.primaryColor.withOpacity(0.5);
          }
          return gray300;
        }),
      ),

      // 다이얼로그 테마
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
        elevation: 8,
      ),

      // Bottom Sheet 테마
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXLarge),
          ),
        ),
      ),

      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: colorTheme.primaryColor.withOpacity(0.1),
        labelStyle: labelMedium.copyWith(color: colorTheme.primaryColor),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    );
  }

  // Dark Theme 생성
  static ThemeData darkTheme(AppColorTheme colorTheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // 색상 스키마
      colorScheme: ColorScheme.dark(
        primary: colorTheme.primaryColor,
        secondary: colorTheme.secondaryColor,
        surface: darkGray800,
        surfaceContainerHighest: darkGray700,
        onSurface: darkGray200,
        onSurfaceVariant: darkGray400,
        error: errorRed,
        onError: Colors.white,
        outline: darkGray600,
        outlineVariant: darkGray700,
      ),

      scaffoldBackgroundColor: darkGray900,
      fontFamily: 'Pretendard',

      // 앱바 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkGray200,
        ),
        iconTheme: IconThemeData(color: darkGray400),
        surfaceTintColor: Colors.transparent,
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: colorTheme.primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorTheme.primaryColor,
          side: BorderSide(color: colorTheme.primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray700,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: darkGray600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide(color: colorTheme.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed),
        ),
        contentPadding: const EdgeInsets.all(spaceMedium),
        hintStyle: const TextStyle(color: darkGray400),
      ),

      // 스위치 테마
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorTheme.primaryColor;
          }
          return darkGray500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorTheme.primaryColor.withOpacity(0.5);
          }
          return darkGray600;
        }),
      ),

      // 다이얼로그 테마
      dialogTheme: DialogThemeData(
        backgroundColor: darkGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
        elevation: 8,
      ),

      // Bottom Sheet 테마
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkGray800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXLarge),
          ),
        ),
      ),

      // 칩 테마
      chipTheme: ChipThemeData(
        backgroundColor: colorTheme.primaryColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: colorTheme.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),

      // 분할선 테마
      dividerTheme: const DividerThemeData(color: darkGray700, thickness: 1),
    );
  }
}
