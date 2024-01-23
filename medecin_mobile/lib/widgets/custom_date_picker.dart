import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

// ignore: must_be_immutable
class CustomDatePiker extends StatefulWidget {
  String? value;
  final Function(String)? onChanged;
  CustomDatePiker({super.key, this.value, this.onChanged});

  @override
  State<CustomDatePiker> createState() => _CustomDatePikerState();
}

class _CustomDatePikerState extends State<CustomDatePiker> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),  
        border: Border.all(color: AppColors.blue500, width: 2),
      ),
      child: InkWell(
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: widget.value != null ? DateTime(
              int.parse(widget.value!.split('/')[2]), // year
              int.parse(widget.value!.split('/')[1]), // month
              int.parse(widget.value!.split('/')[0]), // day
            ) : DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
            locale: const Locale('fr', 'FR'),
          ).then((value) {
            if (value != null) {
              setState(() {
                widget.value = '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year.toString()}';
              });
              widget.onChanged?.call(
                '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year.toString()}'
              );
            }
          });
        },
        child: Row(
          children: [
            Text(
              widget.value ?? 'Séléctionner une date',
              style: TextStyle(
                color: widget.value != null ? AppColors.black : AppColors.grey400,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const Icon(
              BootstrapIcons.calendar3,
              color: AppColors.grey400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}