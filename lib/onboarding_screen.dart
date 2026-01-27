import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/screen/login_screen.dart';
import 'package:rajemployment/utils/location_service.dart';
import 'package:rajemployment/utils/right_to_left_route.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocationService.getCurrentLocation();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Illustration
            Expanded(
              flex: 6,
              child: Center(
                child: Image.asset(
                  "assets/images/splashonboard.png", // your illustration
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      RightToLeftRoute(
                        page: LoginScreen(),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 3,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
