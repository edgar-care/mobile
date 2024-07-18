import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DeviceTab extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String info;
  final Function onTap;
  final String type; // Ajout de la propriété type
  final Widget? outlineIcon;
  final Color? color;
  const DeviceTab({super.key,
      required this.icon,
      required this.info,
      required this.subtitle,
      required this.title,
      required this.onTap,
      required this.type,
      this.outlineIcon,
      this.color});

  @override
  State<DeviceTab> createState() => _DeviceTabState();
}

class _DeviceTabState extends State<DeviceTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border:Border(
            bottom: widget.type == 'Bottom' || widget.type == 'Only'
                ? const BorderSide(color: Colors.transparent, width: 1)
                : const BorderSide(color: AppColors.blue200, width: 1),
          ),
          borderRadius: BorderRadius.only(
            topLeft: widget.type == 'Only' || widget.type == 'Top'
                ? const Radius.circular(16)
                : const Radius.circular(0),
            topRight: widget.type == 'Only' || widget.type == 'Top'
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomLeft: widget.type == 'Bottom' || widget.type == 'Only'
                ? const Radius.circular(18)
                : const Radius.circular(0),
            bottomRight: widget.type == 'Bottom' || widget.type == 'Only'
                ? const Radius.circular(18)
                : const Radius.circular(0),
          ),
        ),
        child: Row(
          children: [
            widget.icon == 'Phone' ? SvgPicture.asset('assets/images/utils/phone-fill.svg') : SvgPicture.asset('assets/images/utils/laptop-fill.svg'),
            Column(
              children: [
                Text(widget.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),),
                Text(widget.subtitle, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500)),
                Text(widget.info, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500)),  
              ],
            ),
            const Spacer(),
            widget.outlineIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}