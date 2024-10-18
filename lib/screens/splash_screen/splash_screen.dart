import 'package:flutter/material.dart';
import 'package:pluspay/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  final String deviceType;
  const SplashScreen({
    super.key,
    required this.deviceType,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final double screenRatio = screenSize.height / screenSize.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/PlusPay.svg',
                width: screenRatio * 100,
              ),
              const CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.accentColor),
                strokeCap: StrokeCap.round,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
