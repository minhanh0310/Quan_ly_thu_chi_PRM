import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  bool get isLightMode => Theme.of(this).brightness == Brightness.light;

  // primary colors

  /// Primary color (#3629B7) - Same in both themes
  Color get primaryColor => Theme.of(this).primaryColor;

  /// Primary color from ColorScheme
  Color get primary => Theme.of(this).colorScheme.primary;

  /// Secondary color (Income green #00D09E)
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Tertiary color (Expense pink #FF6B93)
  Color get tertiaryColor => Theme.of(this).colorScheme.tertiary;

  // background colors

  /// Main background color
  /// Light: #FEFEFE | Dark: #1B262C
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  /// Surface color (Cards, Dialogs, AppBar)
  /// Light: #FFFFFF | Dark: #222E34
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;

  /// Surface variant (Lighter surface / Secondary background)
  /// Light: #F5F6FA | Dark: #29363D
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceContainerHighest;

  /// Card background color
  /// Light: #FFFFFF | Dark: #222E34
  Color get cardColor => Theme.of(this).cardTheme.color ?? surfaceColor;

  // ==================== TEXT COLORS ====================

  /// Primary text color
  /// Light: #1D1E20 | Dark: #FFFFFF
  Color get primaryTextColor => Theme.of(this).colorScheme.onSurface;

  /// Secondary text color (Grey text)
  /// Light: #8F959E | Dark: #A0A0A0
  Color get secondaryTextColor {
    return isDarkMode ? const Color(0xFFA0A0A0) : const Color(0xFF8F959E);
  }

  /// Text color on primary color (always white)
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;

  /// Text color on background
  Color get onBackgroundColor => Theme.of(this).colorScheme.onSurface;

  /// Text color on surface
  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;

  // ==================== UI ELEMENT COLORS ====================

  /// Border color
  /// Light: #E0E0E0 | Dark: #3A3A3A
  Color get borderColor => Theme.of(this).colorScheme.outline;

  /// Divider color
  /// Light: #E0E0E0 | Dark: rgba(255,255,255,0.1)
  Color get dividerColor => Theme.of(this).dividerTheme.color ?? borderColor;

  /// Input field fill color
  /// Light: #F5F6FA | Dark: #222E34
  Color get inputFillColor {
    return isDarkMode ? const Color(0xFF222E34) : const Color(0xFFF5F6FA);
  }

  /// Icon color (same as primary text)
  Color get iconColor => primaryTextColor;

  /// Hint text color
  /// Light: #8F959E | Dark: #808080
  Color get hintColor {
    return isDarkMode ? const Color(0xFF808080) : const Color(0xFF8F959E);
  }

  // ==================== SEMANTIC COLORS ====================

  /// Success color (Green #00D09E) - Same in both themes
  Color get successColor => const Color(0xFF00D09E);

  /// Error color (Red #FF4747) - Same in both themes
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Warning color (Yellow #FFC94D) - Same in both themes
  Color get warningColor => const Color(0xFFFFC94D);

  /// Info color (Purple #4A3FD9) - Same in both themes
  Color get infoColor => const Color(0xFF4A3FD9);

  // ==================== INCOME/EXPENSE COLORS ====================

  /// Income color (Green #00D09E) - Same in both themes
  Color get incomeColor => const Color(0xFF00D09E);

  /// Income background color
  /// Light: #E8F8F4 (light green) | Dark: #1A3A32 (dark green)
  Color get incomeBackgroundColor {
    return isDarkMode ? const Color(0xFF1A3A32) : const Color(0xFFE8F8F4);
  }

  /// Expense color (Pink #FF6B93) - Same in both themes
  Color get expenseColor => const Color(0xFFFF6B93);

  /// Expense background color
  /// Light: #FFE8EE (light pink) | Dark: #3A1A24 (dark pink)
  Color get expenseBackgroundColor {
    return isDarkMode ? const Color(0xFF3A1A24) : const Color(0xFFFFE8EE);
  }

  // ==================== COMPONENT SPECIFIC ====================

  /// AppBar background color
  /// Light: #FFFFFF | Dark: #1B262C
  Color get appBarColor {
    return Theme.of(this).appBarTheme.backgroundColor ?? surfaceColor;
  }

  /// Bottom Navigation background color
  /// Light: #FFFFFF | Dark: #29363D
  Color get bottomNavColor {
    return Theme.of(this).bottomNavigationBarTheme.backgroundColor ??
        surfaceVariant;
  }

  /// Drawer background color
  /// Light: #FFFFFF | Dark: #1B262C
  Color get drawerColor {
    return Theme.of(this).drawerTheme.backgroundColor ?? backgroundColor;
  }

  /// Button background color (for containers styled as buttons)
  /// Light: #F5F6FA | Dark: #222E34
  Color get buttonBackgroundColor {
    return isDarkMode ? const Color(0xFF222E34) : const Color(0xFFF5F6FA);
  }

  // Shadow and overlay

  /// Shadow color for elevation
  /// Light: rgba(0,0,0,0.05) | Dark: rgba(0,0,0,0.3)
  Color get shadowColor {
    return isDarkMode
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.05);
  }

  /// Overlay color (for modals, dialogs)
  /// Both themes: rgba(0,0,0,0.5)
  Color get overlayColor {
    return Colors.black.withValues(alpha: 0.5);
  }

  /// Shimmer base color (for loading states)
  /// Light: #E0E0E0 | Dark: #222E34
  Color get shimmerBaseColor {
    return isDarkMode ? const Color(0xFF222E34) : const Color(0xFFE0E0E0);
  }

  /// Shimmer highlight color (for loading states)
  /// Light: #F5F5F5 | Dark: #29363D
  Color get shimmerHighlightColor {
    return isDarkMode ? const Color(0xFF29363D) : const Color(0xFFF5F5F5);
  }

  // ==================== TEXT STYLES ====================

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Display large text style (32px, bold)
  TextStyle? get displayLarge => textTheme.displayLarge;

  /// Display medium text style (24px, bold)
  TextStyle? get displayMedium => textTheme.displayMedium;

  /// Title large text style (20px, w600)
  TextStyle? get titleLarge => textTheme.titleLarge;

  /// Title medium text style (16px, w600)
  TextStyle? get titleMedium => textTheme.titleMedium;

  /// Body large text style (16px, normal)
  TextStyle? get bodyLarge => textTheme.bodyLarge;

  /// Body medium text style (14px, grey)
  TextStyle? get bodyMedium => textTheme.bodyMedium;

  /// Body small text style (12px, grey)
  TextStyle? get bodySmall => textTheme.bodySmall;

  /// Label large text style (16px, w600, white)
  TextStyle? get labelLarge => textTheme.labelLarge;

  // ==================== UTILITY METHODS ====================

  /// Get color with opacity
  Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get lighter shade of color
  Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Get darker shade of color
  Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }


  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if screen is small (< 360dp)
  bool get isSmallScreen => screenWidth < 360;

  /// Check if screen is medium (360-600dp)
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;

  /// Check if screen is large (>= 600dp)
  bool get isLargeScreen => screenWidth >= 600;
}
