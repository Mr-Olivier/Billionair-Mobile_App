import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final VoidCallback onResetPressed;
  final bool isDarkMode;

  const ResetButton({
    Key? key,
    required this.onResetPressed,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: onResetPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          foregroundColor: isDarkMode ? Colors.white70 : Colors.black87,
          elevation: isDarkMode ? 3 : 1,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.refresh, size: 24),
            SizedBox(height: 4),
            Text(
              'RESET',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
