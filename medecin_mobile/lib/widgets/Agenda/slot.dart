import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/slot_service.dart';
import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;



enum SlotType { empty, taken, create }

// ignore: must_be_immutable
class Slot extends StatefulWidget {
  late SlotType type;
  final String? patientName;
  final bool? three;
  final DateTime? date;
  String? id;
  List <dynamic>? slots;
  Slot(
      {super.key,
      required this.type,
      this.date,
      this.id,
      this.patientName,
      this.three,
      this.slots});

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  Future<void> loadSlots() async {
    var tempslots = await getSlot();
    setState(() {
      widget.slots = tempslots;
    });
  }

  void updateSlotType(SlotType types) {
    loadSlots();
    setState(() {
      widget.type = types;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation, // Utilisez l'animation pour l'opacité
      child: Builder(
        builder: (BuildContext context) {
          switch (widget.type) {
            case SlotType.empty:
              return SlotEmpty(
                  three: widget.three ?? false,
                  updateSlotType: updateSlotType,
                  date: widget.date!);
            case SlotType.taken:
              return SlotTaken(
                  patientName: widget.patientName ?? "Nom du patient",
                  three: widget.three ?? false);
            case SlotType.create:
              return SlotCreate(
                  three: widget.three ?? false,
                  updateSlotType: updateSlotType, date: widget.date!, slots: widget.slots!,);
            default:
              return Container(); // ou un autre widget par défaut
          }
        },
      ),
    );
  }
}

class SlotEmpty extends Card {
  final bool three;
  final Function updateSlotType;
  final DateTime date;
  const SlotEmpty(
      {super.key,
      required this.three,
      required this.updateSlotType,
      required this.date,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),),
      width: three == false
          ? MediaQuery.of(context).size.width - 108
          : MediaQuery.of(context).size.width * 0.236,
      child: InkWell(
        onTap: () {
          postSlot(date).then((value) => updateSlotType(SlotType.create));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [ 
              Text(!three ? "Ouvrir le créneau" : ( MediaQuery.of(context).size.width > 380 ? "Ouvrir" : ""),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey700)),
              const Spacer(),
              const Icon(BootstrapIcons.plus_circle_fill,
                  size: 16, color: AppColors.grey700)
            ],
          ),
        ),
      ),
    );
  }
}

class SlotCreate extends Card {
  final bool three;
  final Function updateSlotType;
  final DateTime date;
  final List<dynamic> slots;
  const SlotCreate(
      {super.key,
      required this.three,
      required this.updateSlotType,
      required this.date, required this.slots});

  @override
  Widget build(BuildContext context) {
    String id;

  String parsing(DateTime date, List<dynamic> slots) {
    for (var i = 0; i < slots.length; i++) {
      if (slots[i]['start_date'] * 1000 == date.millisecondsSinceEpoch) {
        return slots[i]['id'];
      }
    }
    return "";
  }
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.blue200, width: 2)),
      ),
      width: three == false
          ? MediaQuery.of(context).size.width - 108
          : MediaQuery.of(context).size.width * 0.236,
      child: InkWell(
        onTap: () {
          id = parsing(date, slots);
          deleteSlot(id).then((value) => updateSlotType(SlotType.empty));
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: AppColors.green500,
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(three == false ? "Fermer le créneau" : ( MediaQuery.of(context).size.width > 380 ? "Fermer" : ""),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey700)),
                const Spacer(),
                Transform.rotate(
                    angle: 45 * math.pi / 180,
                    child: const Icon(BootstrapIcons.plus_circle_fill,
                        size: 16, color: AppColors.grey700))
              ],
            )),
      ),
    );
  }
}

class SlotTaken extends Card {
  final String patientName;
  final bool three;
  const SlotTaken(
      {super.key,
      required this.patientName,
      required this.three,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blue200,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      width: three == false
          ? MediaQuery.of(context).size.width - 108
          : MediaQuery.of(context).size.width * 0.236,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 15,
                decoration: const BoxDecoration(
                  color: AppColors.red500,
                  borderRadius: BorderRadius.all(Radius.circular(60.0)),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(three == false ? patientName :  ( MediaQuery.of(context).size.width > 380 ? "Réservé" : ""),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )),
    );
  }
}
