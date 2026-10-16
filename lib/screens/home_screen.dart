import 'package:flutter/material.dart';
import 'package:ventur_2/screens/mode_select_screen.dart';
import 'package:ventur_2/utils/sizes.dart';
import 'package:ventur_2/widgets/display_buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Open settings
            },
            icon: const Icon(Icons.settings, size: 32, color: Colors.white),
          ),
          const SizedBox(
            width: AppSizes.sm,
          ), // Add some spacing between the buttons
        ],
      ),

      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_home.png',
              fit: BoxFit.cover,
            ),
          ),

          // Your title/content
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Guess the',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.xxl,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Country',
                  style: GoogleFonts.poppins(
                    fontSize: AppSizes.xxl,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),

          // Bottom buttons
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Buttons(
                    text: 'Play',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ModeSelectScreen(),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.sm),

                  Buttons(text: 'Daily Challenge', onPressed: () {}),

                  const SizedBox(height: AppSizes.sm),

                  Buttons(text: 'Categories', onPressed: () {}),

                  const SizedBox(height: AppSizes.sm),

                  Buttons(text: 'Statistics', onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
