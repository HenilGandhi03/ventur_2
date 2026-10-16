import 'package:flutter/material.dart';
import 'package:ventur_2/widgets/category_card.dart';

class ModeSelectScreen extends StatelessWidget {
  const ModeSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Mode'),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          CategoryCard(
            title: 'Classic',
            description: 'Guess the country from a single image.',
            imagePath: 'assets/images/home_background.jpeg',
            onTap: () {
              // Handle button press
            },
          ),
          CategoryCard(
            title: 'Landmark',
            description: 'Famous places and landmarks from around the world.',
            imagePath: 'assets/images/landmark.jpg',
            onTap: () {
              // Handle button press
            },
          ),
          CategoryCard(
            title: 'Food',
            description:
                'Guess the country through its traditional dishes and cuisine.',
            imagePath: 'assets/images/food.jpg',
            onTap: () {
              // Handle button press
            },
          ),
          CategoryCard(
            title: 'Culture',
            description: 'Guess the country through its cultural aspects.',
            imagePath: 'assets/images/culture.jpg',
            onTap: () {
              // Handle button press
            },
          ),
          CategoryCard(
            title: 'Mixed',
            description:
                'A mix of different categories for a challenging experience.',
            imagePath: 'assets/images/mixed.jpg',
            onTap: () {
              // Handle button press
            },
          ),
        ],
      ),
    );
  }
}
