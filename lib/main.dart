import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:device_preview/device_preview.dart';
import 'core/router/app_router.dart';
import 'core/theme/gradient_theme.dart';
import 'data/datasources/database_helper.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize locale data for intl package
  await initializeDateFormatting('id_ID', null);

  // Initialize database
  final database = await DatabaseHelper.initDatabase();

  // Initialize notification service
  await NotificationService().initialize();

  runApp(
    DevicePreview(
      enabled: false, // Set to false for production
      builder: (context) => ProviderScope(
        overrides: [
          // Override database provider with actual database instance
          databaseProvider.overrideWithValue(database),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme provider to rebuild when theme changes
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X baseline
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          // DevicePreview configuration
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,

          title: 'Aplikasi Pencatatan Keuangan',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,

          // Theme configuration
          themeMode: themeNotifier.themeMode,

          // Light theme - Teal & Coral
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: GradientTheme.lightPrimary,
              brightness: Brightness.light,
              primary: GradientTheme.lightPrimary,
              secondary: GradientTheme.lightAccent,
              background: GradientTheme.lightBackground,
              surface: GradientTheme.lightSurface,
            ),
            scaffoldBackgroundColor: GradientTheme.lightBackground,
            cardColor: GradientTheme.lightSurface,
            fontFamily: 'SFRegular',
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: GradientTheme.lightTextPrimary),
              bodyMedium: TextStyle(color: GradientTheme.lightTextPrimary),
              bodySmall: TextStyle(color: GradientTheme.lightTextSecondary),
              titleLarge: TextStyle(color: GradientTheme.lightTextPrimary),
              titleMedium: TextStyle(color: GradientTheme.lightTextPrimary),
              titleSmall: TextStyle(color: GradientTheme.lightTextSecondary),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),

          // Dark theme - Slate & Neon Pastel
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: GradientTheme.darkPrimary,
              brightness: Brightness.dark,
              primary: GradientTheme.darkPrimary, // #2DD4BF Teal Pastel
              secondary: GradientTheme.darkAccent, // #FB7185 Soft Rose
              background: GradientTheme.darkBackground, // #0F172A
              surface: GradientTheme.darkSurface, // #1E293B
            ),
            scaffoldBackgroundColor: GradientTheme.darkBackground,
            cardColor: GradientTheme.darkSurface,
            fontFamily: 'SFRegular',
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: GradientTheme.darkTextPrimary),
              bodyMedium: TextStyle(color: GradientTheme.darkTextPrimary),
              bodySmall: TextStyle(color: GradientTheme.darkTextSecondary),
              titleLarge: TextStyle(color: GradientTheme.darkTextPrimary),
              titleMedium: TextStyle(color: GradientTheme.darkTextPrimary),
              titleSmall: TextStyle(color: GradientTheme.darkTextSecondary),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
