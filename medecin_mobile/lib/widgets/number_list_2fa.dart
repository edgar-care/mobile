import 'package:edgar/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FieldNumberList2FA extends StatefulWidget {
  Function addCode;
  FieldNumberList2FA({super.key, required this.addCode});

  @override
  State<FieldNumberList2FA> createState() => _FieldNumberList2FAState();
}

class _FieldNumberList2FAState extends State<FieldNumberList2FA> {
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: NumberField(
              focusNode: focusNodes[index],
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  focusNodes[index + 1].requestFocus();
                  widget.addCode('ADD', value);
                } else if (value.isEmpty && index > 0) {
                  focusNodes[index].unfocus();
                  focusNodes[index - 1].requestFocus();
                  widget.addCode('DELETE', '');
                }
                if (value.isNotEmpty && index == 5) {
                  focusNodes[index].unfocus();
                  widget.addCode('ADD', value);
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

class NumberField extends StatelessWidget {
  final FocusNode focusNode;
  final Function(String) onChanged;

  const NumberField({
    super.key,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.blue300,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 1,
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        onChanged: (value) {
          onChanged(value);
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        autofocus: true,
        enableInteractiveSelection: false,
        showCursor: false,
      ),
    );
  }
}
