import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:Quan_ly_thu_chi_PRM/core/theme/theme_provider.dart';
import 'package:Quan_ly_thu_chi_PRM/core/routers/routes.dart';
import 'firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  // khoi tao truoc khi chay app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await EasyLocalization.ensureInitialized();

  // final db = FirebaseDatabase.instance.ref('test/message');
  // await db.set('Hello, Firebase Realtime Database!');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('vi', 'VN')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  String? _initialRoute;
  Object? _initialArgs;

  @override
  void initState() {
    super.initState();
    _handleInitialDeepLink();
  }

  /// Checks for initial deep link on cold start
  Future<void> _handleInitialDeepLink() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _processDeepLink(initialUri);
    }
  }

  /// Processes a deep link and determines which route to navigate to
  void _processDeepLink(Uri uri) {
    final mode = uri.queryParameters['mode'];
    final oobCode = uri.queryParameters['oobCode'];

    // Check if this is an email verification link
    if (mode == 'verifyEmail' && oobCode != null) {
      setState(() {
        _initialRoute = AppRoutes.emailVerification;
        _initialArgs = null; // The EmailVerificationScreen will handle the deep link directly
      });
    }
    // Check if this is a password reset link
    else if (mode == 'resetPassword' && oobCode != null) {
      setState(() {
        _initialRoute = AppRoutes.resetPassword;
        _initialArgs = null; // The ResetPasswordScreen will handle the deep link directly
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Expense Managing App',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: themeProvider.currentTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            );
          },
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: _initialRoute ?? AppRoutes.splash,
        );
      },
    );
  }
}
