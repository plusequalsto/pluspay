import 'package:fluro/fluro.dart';
import 'package:pluspay/models/products.dart';
import 'package:pluspay/screens/authentication_screen/signin_screen.dart';
import 'package:pluspay/screens/checkout_screen/checkout_screen.dart';
import 'package:pluspay/screens/home_screen/home_screen.dart';
import 'package:pluspay/screens/password_reset_screen/password_reset_screen.dart';
import 'package:pluspay/screens/shop_screen/shop_screen.dart';
import 'package:pluspay/screens/splash_screen/splash_screen.dart';
import 'package:realm/realm.dart';

void defineRoutes(FluroRouter router) {
  // Splash Screen
  router.define(
    '/splash',
    handler: Handler(
      handlerFunc: (context, params) {
        final args = context?.settings?.arguments as Map<String, dynamic>;
        String deviceType = args['deviceType'];
        return SplashScreen(
          deviceType: deviceType,
        );
      },
    ),
  );
  // Password Reset Screen
  router.define(
    '/signin',
    handler: Handler(
      handlerFunc: (context, params) {
        final args = context?.settings?.arguments as Map<String, dynamic>;
        Realm realm = args['realm'];
        String deviceToken = args['deviceToken'];
        String deviceType = args['deviceType'];
        return SigninScreen(
          realm: realm,
          deviceToken: deviceToken,
          deviceType: deviceType,
        );
      },
    ),
  );
  // Password Reset Screen
  router.define(
    '/passwordreset',
    handler: Handler(
      handlerFunc: (context, params) {
        // final args = context?.settings?.arguments as Map<String, dynamic>;
        // String deviceType = args['deviceType'];
        return const PasswordResetScreen();
      },
    ),
  );
  // Home Screen
  router.define(
    '/home',
    handler: Handler(
      handlerFunc: (context, params) {
        final args = context?.settings?.arguments as Map<String, dynamic>;
        Realm realm = args['realm'];
        String deviceToken = args['deviceToken'];
        String deviceType = args['deviceType'];
        return HomeScreen(
          realm: realm,
          deviceToken: deviceToken,
          deviceType: deviceType,
        );
      },
    ),
  );
  // Shop Screen
  router.define(
    '/shop',
    handler: Handler(
      handlerFunc: (context, params) {
        final args = context?.settings?.arguments as Map<String, dynamic>;
        Realm realm = args['realm'];
        String deviceToken = args['deviceToken'];
        String deviceType = args['deviceType'];
        return ShopScreen(
          realm: realm,
          deviceToken: deviceToken,
          deviceType: deviceType,
        );
      },
    ),
  );
  // Checkout Screen
  router.define(
    '/checkout',
    handler: Handler(
      handlerFunc: (context, params) {
        final args = context?.settings?.arguments as Map<String, dynamic>;
        Realm realm = args['realm'];
        Map<String, int> cart = args['cart'];
        List<Products> products = args['products'];
        String deviceToken = args['deviceToken'];
        String deviceType = args['deviceType'];
        return CheckoutScreen(
          realm: realm,
          cart: cart,
          products: products,
          deviceToken: deviceToken,
          deviceType: deviceType,
        );
      },
    ),
  );
}
