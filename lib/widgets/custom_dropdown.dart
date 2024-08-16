import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomDropdown extends StatelessWidget {
  final int value;
  final Function(int?) onChanged;

  const CustomDropdown({Key? key, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppTheme.lightGrey,
      ),
      child: DropdownButton<int>(
        value: value,
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryRed),
        items: List.generate(25, (index) => index + 1).map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text('$value. Mal'),
          );
        }).toList(),
        onChanged: onChanged,
        style: TextStyle(color: AppTheme.textColor, fontSize: 16),
        dropdownColor: Colors.white,
      ),
    );
  }
}