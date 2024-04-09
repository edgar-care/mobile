import 'package:flutter/material.dart';
import '../styles/colors.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class CustomField extends StatefulWidget {
  final String label;
  final IconData? icon; // Changed from IconData to IconData?
  final bool isPassword;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String value; // Added onChanged parameter
  final int? maxSize;
  final TextInputAction action;

  const CustomField({
    super.key,
    required this.label,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    this.value = '',
    this.maxSize,
    required this.action,
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
          // ignore: prefer_null_aware_operators
          width: widget.maxSize != null ? widget.maxSize?.toDouble() : null,
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
                  obscureText: widget.isPassword && !_isPasswordVisible,
                  keyboardType: _isPasswordVisible
                      ? TextInputType.text
                      : TextInputType.emailAddress,
                  textInputAction: widget.action,
                  initialValue: widget.value,
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
                  onChanged: widget.onChanged,
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

class CustomFieldSearch extends StatefulWidget {
  final String label;
  final IconData
      icon; // Utilisation de IconData au lieu de Icon pour la cohérence
  final TextInputType keyboardType;
  final Function(String) onValidate;

  const CustomFieldSearch({
    super.key,
    required this.label,
    required this.icon,
    required this.keyboardType,
    required this.onValidate,
  });

  @override
  State<CustomFieldSearch> createState() => _CustomFieldSearchState();
}

class _CustomFieldSearchState extends State<CustomFieldSearch> {
  final TextEditingController _controller = TextEditingController();

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
                  controller: _controller,
                  keyboardType: widget.keyboardType,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    color: AppColors.grey950,
                    fontFamily: 'Poppins',
                    fontSize: 14,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textBaseline: TextBaseline.ideographic,
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    widget.onValidate(value);
                  },
                ),
              ),
              GestureDetector(
                child: Icon(widget.icon, color: AppColors.grey950, size: 16),
                onTap: () {
                  widget.onValidate(_controller.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class CustomAutoComplete extends StatefulWidget {
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final Function(String) onValidate;
  final List<String> suggestions; // Added for suggestions list

  const CustomAutoComplete({
    super.key,
    required this.label,
    required this.icon,
    required this.keyboardType,
    required this.onValidate,
    required this.suggestions, // Added for suggestions list
  });

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Adjust padding as needed
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
                color: AppColors.blue500,
                width: 2.0), // Adjust border color and width if desired
          ),
          child: Row(
            children: [
              Expanded(
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return widget.suggestions.where((suggestion) => suggestion
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  onSelected: (String value) {
                    _controller.text = value;
                    widget.onValidate(value);
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: widget.keyboardType,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(
                        color: AppColors.grey950,
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        textBaseline: TextBaseline.ideographic,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.label,
                        border: InputBorder
                            .none, // Remove border for seamless appearance
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      elevation: 4.0,
                      child: ListView.separated(
                        // Improved suggestion list presentation
                        padding: EdgeInsets.zero, // Remove default padding
                        itemCount: options.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 0.5),
                        itemBuilder: (context, index) => ListTile(
                          title: Text(options.elementAt(
                              index)), // Use elementAt to access elements
                          onTap: () => onSelected(options.elementAt(
                              index)), // Use elementAt to access elements
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                child: Icon(widget.icon, color: AppColors.grey950, size: 16.0),
                onTap: () => widget.onValidate(_controller.text),
              ),
            ],
          ),
        );
      },
    );
  }
}
