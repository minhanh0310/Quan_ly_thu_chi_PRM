import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? _darkTheme : _lightTheme;

  ThemeProvider() {
    _loadTheme();
  }
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_themeKey) ?? false;
      notifyListeners();
      debugPrint(' Theme loaded: ${_isDarkMode ? 'Dark' : 'Light'}');
    } catch (e) {
      debugPrint(' Error loading theme: $e');
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, _isDarkMode);
      debugPrint('Theme saved: ${_isDarkMode ? 'Dark' : 'Light'}');
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }


  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }

  /// Set theme explicitly
  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;

    _isDarkMode = value;
    await _saveTheme();
    notifyListeners();
  }

  // Define custom colors
  static const Color primaryPurple = Color(0xFF3629B7); // Màu chính dự án
  static const Color lightPurple = Color(0xFF4A3FD9); // Màu tím nhạt
  static const Color darkPurple = Color(0xFF2B1F99); // Màu tím đậm
  static const Color accentPink = Color(0xFFFF6B93); // Màu hồng accent
  static const Color accentYellow = Color(0xFFFFC94D); // Màu vàng accent
  static const Color accentGreen = Color(0xFF00D09E); // Màu xanh lá (Income)
  static const Color backgroundWhite = Color(0xFFFEFEFE);

  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: backgroundWhite, // #FEFEFE
    fontFamily: 'Inter', // Default font cho app
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: primaryPurple, // ✅ #3629B7
      secondary: accentGreen, // #00D09E (Income)
      tertiary: accentPink, // #FF6B93 (Expense)
      primaryContainer: Color(0xFFE8E7FF),
      surface: Color(0xFFFFFFFF), // #FFFFFF
      error: Color(0xFFFF4747),
      inverseSurface: Color(0xFF29363D),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1D1E20), //  Text color
      outline: Color(0xFFE0E0E0), // Border color
      surfaceContainerHighest: Color(0xFFF5F6FA), // Secondary background
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF), // White AppBar
      foregroundColor: Color(0xFF1D1E20), // Dark text
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFF1D1E20),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      iconTheme: IconThemeData(color: Color(0xFF1D1E20)),
    ),

    // FloatingActionButton Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D1E20),
        fontFamily: 'Inter',
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D1E20),
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1D1E20),
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1D1E20),
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Color(0xFF1D1E20),
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFF8F959E), // Secondary text 
        fontFamily: 'Inter',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color(0xFF8F959E),
        fontFamily: 'Inter',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F6FA), // Từ theme cũ
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      // Border thường
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),

      // Border khi được chọn
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),

      // Border khi có lỗi
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF4747), width: 1),
      ),

      // Hint text style
      hintStyle: const TextStyle(
        color: Color(0xFF8F959E),
        fontSize: 14,
        fontFamily: 'Inter',
      ),

      // Label style
      labelStyle: const TextStyle(
        color: Color(0xFF1D1E20),
        fontSize: 14,
        fontFamily: 'Inter',
      ),

      // Floating label style
      floatingLabelStyle: const TextStyle(
        color: primaryPurple,
        fontSize: 16,
        fontFamily: 'Inter',
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryPurple.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPurple,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: primaryPurple, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryPurple,
      unselectedItemColor: Color(0xFF8F959E),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Inter'),
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 1,
    ),
  );

  // ==================== DARK THEME ====================
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: const Color(0xFF1B262C), //  Từ theme cũ
    fontFamily: 'Inter',

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: primaryPurple, //  #3629B7
      secondary: accentGreen, // #00D09E (Income)
      tertiary: accentPink, // #FF6B93 (Expense)
      surface: Color(0xFF222E34), //  Từ theme cũ (cards, dialogs)
      surfaceBright: Color(0xFF1B262C), //  Main background
      primaryContainer: Color(0xFF29363D),
      error: Color(0xFFFF4747),
      inverseSurface: Color(0xFFE8E7FF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFFFFFFF), //  White text
      outline: Color(0xFF3A3A3A), // Border color
      surfaceContainerHighest: Color(0xFF29363D), // Secondary surface từ theme cũ
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B262C),
      foregroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    ),

    // FloatingActionButton Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryPurple,
      foregroundColor: Colors.white,
      elevation: 4,
    ),

    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFFA0A0A0), // ✅ Secondary text từ theme cũ
        fontFamily: 'Inter',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFFA0A0A0),
        fontFamily: 'Inter',
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Inter',
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF222E34), // ✅ Từ theme cũ
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3A3A3A), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF4747), width: 1),
      ),

      hintStyle: const TextStyle(
        color: Color(0xFF808080),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      labelStyle: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 14,
        fontFamily: 'Inter',
      ),
      floatingLabelStyle: const TextStyle(
        color: primaryPurple,
        fontFamily: 'Inter',
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryPurple,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF29363D), // ✅ Từ theme cũ
      selectedItemColor: primaryPurple,
      unselectedItemColor: Color(0xFFA0A0A0),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      unselectedLabelStyle: TextStyle(fontSize: 12, fontFamily: 'Inter'),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
    ),
  );

  // ==================== GETTERS FOR CUSTOM COLORS ====================
  // Các getter này để dễ dàng access colors từ bất kỳ đâu
  Color get primaryColor => primaryPurple;
  Color get accentColor => accentPink;
  Color get successColor => accentGreen;
  Color get warningColor => accentYellow;
}
