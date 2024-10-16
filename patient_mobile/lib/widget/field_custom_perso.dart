import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';

class CustomFieldSearchPerso extends StatefulWidget {
  final String label;
  final Widget icon;
  final TextInputType keyboardType;
  final Function(String)? onValidate;
  final Function(String)? onChange;
  final VoidCallback? onOpen;

  const CustomFieldSearchPerso({
    super.key,
    required this.label,
    required this.icon,
    required this.keyboardType,
    this.onValidate,
    this.onChange,
    this.onOpen,
  });

  @override
  State<CustomFieldSearchPerso> createState() => _CustomFieldSearchState();
}

class _CustomFieldSearchState extends State<CustomFieldSearchPerso> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleValidate() {
    if (widget.onValidate != null) {
      widget.onValidate!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blue500, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    color: AppColors.grey950,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    textBaseline: TextBaseline.ideographic,
                  ),
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      minWidth: 0,
                      maxWidth: constraints.maxWidth,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    hintText: widget.label,
                    hintStyle: const TextStyle(
                      color: AppColors.grey400,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onTap: widget.onOpen,
                  onChanged: widget.onChange,
                  onSubmitted: (_) => _handleValidate(),
                ),
              ),
              GestureDetector(
                onTap: _handleValidate,
                child: widget.icon,
              ),
            ],
          ),
        );
      },
    );
  }
}
