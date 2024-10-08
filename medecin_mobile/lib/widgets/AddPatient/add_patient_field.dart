import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';

class AddCustomPreloadField extends StatefulWidget {
  final String label;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final Function()? onTap;
  final bool add;
  final TextEditingController controller;

  const AddCustomPreloadField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    required this.controller,
    this.onTap,
    required this.add,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomPreloadFieldState createState() => _AddCustomPreloadFieldState();
}

class _AddCustomPreloadFieldState extends State<AddCustomPreloadField> {
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
            child: widget.keyboardType == TextInputType.datetime
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: AppColors.blue500,
                          controller: widget.controller,
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
                      if (widget.add)
                        GestureDetector(
                          onTap: () {
                            widget.onTap!();
                          },
                          child: const Icon(
                            BootstrapIcons.plus,
                            color: AppColors.blue700,
                            size: 22,
                          ),
                        ),
                      if (!widget.add)
                        const Icon(BootstrapIcons.calendar3,
                            color: AppColors.grey400, size: 16)
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.blue500, width: 2),
                    ),
                  ));
      },
    );
  }
}
