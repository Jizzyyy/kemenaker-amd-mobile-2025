import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/add_transaction/add_transaction_screen.dart';
import '../../presentation/screens/transaction_detail/transaction_detail_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/draft_transactions/draft_transactions_screen.dart';
import '../../presentation/screens/notification_debug/notification_debug_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/add-transaction',
        name: 'add-transaction',
        pageBuilder: (context, state) {
          final transactionId = state.uri.queryParameters['id'];
          final draftId = state.uri.queryParameters['draftId'];
          return _buildPageWithTransition(
            context,
            state,
            AddTransactionScreen(
              transactionId:
                  transactionId != null ? int.tryParse(transactionId) : null,
              draftId: draftId != null ? int.tryParse(draftId) : null,
            ),
            slideFromBottom: true,
          );
        },
      ),
      GoRoute(
        path: '/transaction-detail/:id',
        name: 'transaction-detail',
        pageBuilder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return _buildPageWithTransition(
            context,
            state,
            TransactionDetailScreen(transactionId: id),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/draft-transactions',
        name: 'draft-transactions',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const DraftTransactionsScreen(),
        ),
      ),
      GoRoute(
        path: '/notification-debug',
        name: 'notification-debug',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const NotificationDebugScreen(),
        ),
      ),
    ],
  );

  // Custom page transition
  static CustomTransitionPage _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    bool slideFromBottom = false,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        final slideAnimation = Tween<Offset>(
          begin: slideFromBottom ? const Offset(0, 1) : const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ));

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  // Helper method to check if onboarding is completed
  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    return hasSeenOnboarding ? '/home' : '/onboarding';
  }
}
