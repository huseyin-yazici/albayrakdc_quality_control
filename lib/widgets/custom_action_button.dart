import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double buttonSize = constraints.maxWidth * 0.8; // Buton boyutunu %80'e düşürdük
          return Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15), // Köşe yuvarlaklığını biraz azalttık
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppTheme.primaryRed,
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(buttonSize * 0.1), // İç boşluğu azalttık
              ),
              onPressed: onPressed,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: buttonSize * 0.3, color: AppTheme.primaryRed), // İkon boyutunu küçülttük
                  SizedBox(height: buttonSize * 0.06),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppTheme.primaryRed,
                      fontSize: buttonSize * 0.1, // Yazı boyutunu küçülttük
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}