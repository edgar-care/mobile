import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final IconData? icon;

  const CustomField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    required this.icon,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomFieldState createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
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
                        textBaseline: TextBaseline.ideographic,
                      ),
                    ),
                    onChanged: widget.onChanged, // Added onChanged
                  ),
                ),
                Icon(widget.icon),
              ],
            ),
          );
        },
      );
    }
}