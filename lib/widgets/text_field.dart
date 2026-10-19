import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onSend;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      textInputAction: TextInputAction.done,

      onSubmitted: (_) {
        onSend?.call();
      },

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(color: Colors.blueGrey.shade300, fontSize: 16),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),

        suffixIcon: IconButton(
          onPressed: onSend,
          icon: const Icon(Icons.send, color: Colors.blue, size: 28),
        ),
      ),
    );
  }
}
