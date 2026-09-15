import 'package:flutter/material.dart';

class NetworkRequestButton extends StatelessWidget {
  final bool isPending;
  final VoidCallback onPressed;

  const NetworkRequestButton({
    super.key,
    required this.isPending,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isPending ? null : onPressed,
        icon: const Icon(Icons.download),
        label: const Text(
          'Simulate Network Request',
        ),
      ),
    );
  }
}