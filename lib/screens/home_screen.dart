import 'package:flutter/material.dart';
import 'package:ventur_2/repositories/composite_progress_storage.dart';
import 'package:ventur_2/screens/credits_screen.dart';
import 'package:ventur_2/screens/mode_select_screen.dart';
import 'package:ventur_2/utils/sizes.dart';
import 'package:ventur_2/widgets/display_buttons.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.copyright_outlined),
                title: const Text('Credits & Attribution'),
                subtitle: const Text('Image sources and licences'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreditsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt, color: Colors.redAccent),
                title: const Text('Reset progress'),
                subtitle: const Text('Start over from level 1 on this device'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _confirmReset(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset progress?'),
          content: const Text(
            'This clears your saved progress on this device and starts you '
            'back at level 1. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await CompositeProgressStorage().clear();
    messenger.showSnackBar(
      const SnackBar(content: Text('Progress reset')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _openSettings(context),
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
