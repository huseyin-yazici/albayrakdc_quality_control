import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.keyboardType,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      style: TextStyle(color: AppTheme.textColor),
      decoration: InputDecoration(
        labelText: widget.label,
        fillColor: AppTheme.lightGrey,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryRed, width: 2),
        ),
      ),
    );
  }
}