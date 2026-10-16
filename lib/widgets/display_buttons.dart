import 'package:flutter/material.dart';
import 'package:ventur_2/utils/sizes.dart';

class Buttons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final ButtonStyle? style;

  const Buttons({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSizes.sm, 0, AppSizes.sm),
      child: SizedBox(
        width: width ?? double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        ),
      ),
    );
  }
}


// Sample Usage:
// Buttons(
//   text: 'Login',
//   onPressed: () {},
// )

// Buttons(
//   text: 'Login',
//   onPressed: () {},
//   width: 200, // Optional width
//   style: ButtonStyle(                                            // Optional custom style
//     shape: MaterialStateProperty.all<RoundedRectangleBorder>(  
//       RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18.0),
//       ),
//     ), 
// )