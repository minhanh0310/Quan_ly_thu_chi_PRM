import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Widget responsive layout dùng chung toàn app.
///
/// Cách dùng đơn giản nhất — chỉ cần wrap body của screen:
///
/// ```dart
/// Scaffold(
///   body: ResponsiveLayout(
///     child: YourWidget(),
///   ),
/// )
/// ```
///
/// Hoặc nếu muốn layout khác nhau theo từng breakpoint:
///
/// ```dart
/// ResponsiveLayout(
///   mobile: MobileWidget(),
///   tablet: TabletWidget(),   // optional
///   desktop: DesktopWidget(), // optional
/// )
/// ```
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    // Max width cho nội dung trên desktop/tablet
    // Mặc định 600 — giống app mobile được canh giữa
    this.maxContentWidth = 600,
    // Có hiển thị side padding trên tablet/desktop không
    this.useSidePadding = true,
    // Có wrap ScrollView không (tiện khi dùng Column)
    this.scrollable = false,
  }) : assert(
         child != null || mobile != null,
         'Phải cung cấp child hoặc mobile',
       );

  final Widget? child;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double maxContentWidth;
  final bool useSidePadding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final bp = ResponsiveBreakpoints.of(context);
    final isMobile = bp.isMobile;
    final isTablet = bp.isTablet;
    final isDesktop = bp.isDesktop || bp.largerThan(DESKTOP);

    // Chọn widget theo breakpoint
    // Fallback về child nếu không có widget riêng
    Widget content;
    if (isDesktop && desktop != null) {
      content = desktop!;
    } else if (isTablet && tablet != null) {
      content = tablet!;
    } else if (isMobile && mobile != null) {
      content = mobile!;
    } else {
      // Dùng child — layout tự co giãn theo ResponsiveFramework
      content = child ?? mobile!;
    }

    // Mobile: full width, không cần wrap
    if (isMobile) {
      return scrollable ? SingleChildScrollView(child: content) : content;
    }

    // Tablet / Desktop: canh giữa với maxWidth
    Widget centered = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: content,
      ),
    );

    if (useSidePadding) {
      final sidePad = isDesktop ? 0.0 : 0.0; // tuỳ chỉnh nếu cần
      centered = Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePad),
        child: centered,
      );
    }

    return scrollable ? SingleChildScrollView(child: centered) : centered;
  }
}

/// Extension tiện lợi để check breakpoint ở bất kỳ đâu
/// trong widget tree mà không cần import responsive_framework.
///
/// Cách dùng:
/// ```dart
/// if (context.isMobile) { ... }
/// if (context.isTablet) { ... }
/// double pad = context.responsivePadding;
/// ```
extension ResponsiveContext on BuildContext {
  ResponsiveBreakpointsData get _bp => ResponsiveBreakpoints.of(this);

  bool get isMobile => _bp.isMobile;
  bool get isTablet => _bp.isTablet;
  bool get isDesktop => _bp.isDesktop || _bp.largerThan(DESKTOP);

  /// Padding ngang responsive:
  /// Mobile = 16, Tablet = 24, Desktop = 32
  double get responsivePadding {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 16;
  }

  /// Font size responsive — nhân hệ số theo màn hình
  /// Mobile = 1.0x, Tablet = 1.1x, Desktop = 1.2x
  double responsiveFontSize(double base) {
    if (isDesktop) return base * 1.2;
    if (isTablet) return base * 1.1;
    return base;
  }

  /// Icon size responsive
  double responsiveIconSize(double base) {
    if (isDesktop) return base * 1.25;
    if (isTablet) return base * 1.1;
    return base;
  }

  /// Trả về giá trị khác nhau theo breakpoint
  /// Cách dùng: context.responsive(mobile: 16, tablet: 24, desktop: 32)
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }
}
