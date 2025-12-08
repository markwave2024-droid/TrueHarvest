import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_new/routes/app_routes.dart';
import 'package:task_new/utils/app_colors.dart';
import 'package:task_new/utils/app_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Request permissions with a small delay to show the splash screen
    await Future.delayed(const Duration(seconds: 1));

    // Request notification permission
    await _requestNotificationPermission();

    // Request location permission
    await _requestLocationPermission();

    // Wait for the remaining time to show the splash screen for at least 3 seconds total
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to auth wrapper using named routes
    AppRoutes.navigateAndReplace(context, AppRoutes.authWrapper);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      await Permission.locationWhenInUse.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo inside branded circle
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                AppConstants.appLogoAssert,
                fit: BoxFit.contain,
              ),
            ),

            // Loader
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.lightBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
