import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:device_preview/device_preview.dart';
import 'core/router/app_router.dart';
import 'data/datasources/database_helper.dart';
import 'presentation/providers/transaction_provider.dart';
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
      enabled: true, // Set to false for production
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2196F3),
            ),
            fontFamily: 'SFRegular',
          ),
        );
      },
    );
  }
}
