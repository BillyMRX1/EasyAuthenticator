import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.isDarkMode,
  });

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDarkMode ? Colors.grey.shade300 : Colors.black,
            ),
            const SizedBox(height: 16),
            Text(
              'No accounts available',
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.grey.shade300 : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have not added any accounts yet.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey.shade300 : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
