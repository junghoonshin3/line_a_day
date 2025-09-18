import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiaryTheme {
  // 색상 정의
  static const Color warmOrange = Color(0xFFF4A261);
  static const Color coralPink = Color(0xFFE76F51);
  static const Color creamWhite = Color(0xFFFDF6E3);
  static const Color warmIvory = Color(0xFFF8F0E3);
  static const Color mintGreen = Color(0xFF2A9D8F);
  static const Color softBrown = Color(0xFF8B5A3C);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color darkText = Color(0xFF3D3D3D);
  static const Color lightText = Color(0xFF6B6B6B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansKR', // 또는 'NotoSansKR'
      // 색상 스킴
      colorScheme: ColorScheme.fromSeed(
        seedColor: warmOrange,
        brightness: Brightness.light,
        primary: warmOrange,
        secondary: coralPink,
        background: creamWhite,
        surface: warmIvory,
        tertiary: mintGreen,
      ),

      // 스캐폴드 배경색
      scaffoldBackgroundColor: creamWhite,

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: creamWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: darkText),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: warmIvory,
        elevation: 2,
        shadowColor: warmOrange.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // 텍스트 테마
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: darkText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: darkText,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: darkText, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: lightText, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: lightText, fontSize: 12),
      ),

      // Input Decoration 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: warmOrange.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: warmOrange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: warmOrange.withOpacity(0.2)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: const TextStyle(color: lightText),
      ),

      // FloatingActionButton 테마
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: coralPink,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ElevatedButton 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: warmOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // TextButton 테마
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: warmOrange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // Divider 테마
      dividerTheme: DividerThemeData(
        color: warmOrange.withOpacity(0.2),
        thickness: 1,
      ),

      // ListTile 테마
      listTileTheme: ListTileThemeData(
        tileColor: warmIvory,
        selectedTileColor: warmOrange.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // BottomNavigationBar 테마 (필요한 경우)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: warmIvory,
        selectedItemColor: warmOrange,
        unselectedItemColor: lightText,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // 다크 테마 (선택사항)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',

      colorScheme: ColorScheme.fromSeed(
        seedColor: warmOrange,
        brightness: Brightness.dark,
        primary: warmOrange,
        secondary: coralPink,
        background: const Color(0xFF2C2C2C),
        surface: const Color(0xFF3A3A3A),
        tertiary: mintGreen,
      ),

      scaffoldBackgroundColor: const Color(0xFF2C2C2C),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: creamWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: creamWhite),
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: creamWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: creamWhite, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(
          color: Color(0xFFB0B0B0),
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }
}
