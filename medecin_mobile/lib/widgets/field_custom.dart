import 'package:flutter/material.dart';
import '../styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class CustomField extends StatefulWidget {
  final String label;
  final IconData? icon; // Changed from IconData to IconData?
  final bool isPassword;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String text; // Added onChanged parameter

  const CustomField({
    super.key,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.text = "",
    required this.keyboardType,
    required this.onChanged, // Added required onChanged parameter
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue500, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  cursorColor: AppColors.blue500,
                  obscureText: widget.isPassword && !_isPasswordVisible,
                  keyboardType: widget.keyboardType,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    color: AppColors.grey950,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    textBaseline: TextBaseline.ideographic,
                  ),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                        minWidth: 0, maxWidth: constraints.maxWidth),
                    border: InputBorder.none,
                    isDense: true,
                    hintText: widget.label,
                    hintStyle: const TextStyle(
                      color: AppColors.grey400,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onChanged: widget
                      .onChanged, // Set onChanged to the provided parameter
                ),
              ),
              if (widget.icon != null)
                Icon(widget.icon!, color: AppColors.grey950, size: 16),
              if (widget.isPassword)
                GestureDetector(
                  child: Icon(
                    _isPasswordVisible
                        ? BootstrapIcons.eye_slash_fill
                        : BootstrapIcons.eye_fill,
                    color: Colors.black,
                    size: 16,
                  ),
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
