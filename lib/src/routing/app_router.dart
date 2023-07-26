import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recleatapp/src/features/good_list/good_detail.dart';
import 'package:recleatapp/src/features/splashscreen.dart';
import 'package:recleatapp/src/features/auth/login_screen.dart';
import 'package:recleatapp/src/features/good_list/home_screen.dart';

enum AppRoute {
  splashscreen,
  loginScreen,
  homeScreen,
  detailScreen,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.splashscreen.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/login_screen',
        name: AppRoute.loginScreen.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/home_screen',
        name: AppRoute.homeScreen.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/good_detail/:good_id',
        name: AppRoute.detailScreen.name,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: GoodDetailScreen(id: state.params['good_id']!),
        ),
      ),
    ],
  );
});
