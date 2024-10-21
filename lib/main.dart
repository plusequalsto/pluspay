import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:pluspay/models/user_model.dart';
import 'package:pluspay/routes/router_provider.dart';
import 'package:pluspay/routes/routes.dart';
import 'package:pluspay/screens/authentication_screen/signin_screen.dart';
import 'package:pluspay/screens/home_screen/home_screen.dart';
import 'package:pluspay/screens/splash_screen/splash_screen.dart';
import 'package:pluspay/services/permission_service.dart';
import 'package:pluspay/utils/custom_snackbar_util.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:realm/realm.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final Logger logger = Logger();
void main() async {
  final router = FluroRouter();
  await dotenv.load(fileName: ".env");
  // Initialize Realm configuration
  final config = Configuration.local([
    UserModel.schema,
  ]);
  final realm = Realm(config);
  UserModel? userModel;
  final results = realm.all<UserModel>();
  if (results.isNotEmpty) {
    userModel = results[0];
  }
  defineRoutes(router);
  runApp(
    RouterProvider(
      router: router,
      child: Main(
        title: '+Pay',
        realm: realm,
        userModel: userModel,
        router: router,
      ),
    ),
  );
}

class Main extends StatefulWidget {
  final String title;
  final Realm realm;
  final UserModel? userModel;
  final FluroRouter router;
  const Main({
    super.key,
    required this.title,
    required this.realm,
    required this.userModel,
    required this.router,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final PermissionService _permissionService = PermissionService();
  bool _loading = true;
  bool _hasLocationPermission = false;
  final String _deviceType = Platform.isAndroid ? 'android' : 'ios';
  String? _deviceToken = '';

  UserModel? getUserData(Realm realm) {
    final results = realm.all<UserModel>();
    if (results.isNotEmpty) {
      return results[0];
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4)).then((value) async {
      setState(() {
        _loading = false;
      });
    });
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission =
        await _permissionService.locationPermission();

    // Handle the permission result if needed
    switch (permission) {
      case LocationPermission.denied:
        _requestPermission();
        break;
      case LocationPermission.deniedForever:
        // Handle the case where permission is denied forever
        break;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        // Permission granted, you can proceed with location services
        break;
      default:
        // Handle unexpected cases
        break;
    }
  }

  Future<void> _requestPermission() async {
    // Request location permission using the PermissionService
    LocationPermission permission =
        await _permissionService.requestLocationPermission();

    // Update the state based on the new permission status
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      setState(() {
        _hasLocationPermission = true;
        _loading = false; // Stop loading if permission granted
      });
    } else {
      _showPermissionDeniedMessage(); // Show the permission denied message
      setState(() {
        _loading = false; // Stop loading if permission denied
      });
    }
  }

  void _showPermissionDeniedMessage() {
    CustomSnackBarUtil.showCustomSnackBar(
      'Location permission is required for this app.',
      success: false,
    );
    setState(() {
      _loading = false; // Stop loading if permission denied
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: CustomSnackBarUtil.rootScaffoldMessengerKey,
      navigatorKey: navigatorKey,
      title: widget.title,
      onGenerateRoute: widget.router.generator,
      home: (_loading == true && _hasLocationPermission == false)
          ? RouterProvider(
              router: widget.router,
              child: SplashScreen(
                deviceType: _deviceType,
              ),
            )
          : initialNavigation(),
    );
  }

  // Initial navigation logic based on user login and token status
  Widget initialNavigation() {
    UserModel? userModel = getUserData(widget.realm);
    return userModel?.id != null
        ? RouterProvider(
            router: widget.router,
            child: HomeScreen(
              realm: widget.realm,
              deviceToken: _deviceToken,
              deviceType: _deviceType,
            ),
          )
        : RouterProvider(
            router: widget.router,
            child: SigninScreen(
              realm: widget.realm,
              deviceToken: _deviceToken,
              deviceType: _deviceType,
            ),
          );
  }
}
