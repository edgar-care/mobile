import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_pro/services/slot_service.dart';
import 'package:edgar_pro/widgets/Agenda/three_days.dart';
import 'package:edgar_pro/widgets/Agenda/Slot_list_three.dart';
import 'package:edgar_pro/widgets/Agenda/custom_dropdown_buttont.dart';
import 'package:edgar_pro/widgets/Agenda/slot_list.dart';
import 'package:flutter/material.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  DateTime date = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  ValueNotifier<int> selected = ValueNotifier(0);
  List<dynamic> slots = [];
  List<dynamic> tempslot = [];

  @override
  initState() {
    super.initState();
    _loadSlots();
  }

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  String capitalise(String date) {
    return date
        .split(' ')
        .map((word) => toBeginningOfSentenceCase(word))
        .join(' ');
  }

  Future<void> _loadSlots() async {
    var tempslots = await getSlot();
    setState(() {
      tempslot = tempslots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: const ValueKey("Header"),
          decoration: BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Image.asset(
                "assets/images/logo/edgar-high-five.png",
                height: 40,
                width: 37,
              ),
              const SizedBox(
                width: 16,
              ),
              const Text(
                "Mon Agenda",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
            ]),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blue200, width: 2)),
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<int>(
                          valueListenable: selected,
                          builder: (context, value, child) {
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Buttons(
                                      variant: value == 0
                                          ? Variant.primary
                                          : Variant.secondary,
                                      size: SizeButton.sm,
                                      msg: const Text("Jour"),
                                      onPressed: () => updateSelection(0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Buttons(
                                      variant: value == 1
                                          ? Variant.primary
                                          : Variant.secondary,
                                      size: SizeButton.sm,
                                      msg: const Text(" 3 Jours"),
                                      onPressed: () => updateSelection(1),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            date = date.subtract(
                                                const Duration(days: 1));
                                          })
                                        },
                                        child: const Icon(
                                          BootstrapIcons.chevron_left,
                                          color: AppColors.blue700,
                                          size: 20,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          setState(() {
                                            date = date
                                                .add(const Duration(days: 1));
                                          })
                                        },
                                        child: const Icon(
                                          BootstrapIcons.chevron_right,
                                          color: AppColors.blue700,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ]);
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      ValueListenableBuilder<int>(
                          valueListenable: selected,
                          builder: (context, value, child) {
                            return selected.value == 0
                                ? Text(
                                    capitalise(DateFormat("yMMMMEEEEd", "fr")
                                        .format(date)),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blue700),
                                  )
                                : ThreeDays(
                                    date: date,
                                  );
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: ValueListenableBuilder<int>(
                          valueListenable: selected,
                          builder: (context, value, child) {
                            return selected.value == 0
                                ? SlotList(date: date)
                                : SlotListThree(
                                    date: date,
                                  );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Buttons(
                        variant: Variant.primary,
                        size: SizeButton.md,
                        msg: const Text('Ajouter un créneau +'),
                        onPressed: () {
                          final model = Provider.of<BottomSheetModel>(context,
                              listen: false);
                          model.resetCurrentIndex();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return Consumer<BottomSheetModel>(
                                builder: (context, model, child) {
                                  return ListModal(
                                    model: model,
                                    children: [SlotAdd(tempslot: tempslot)],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ])),
          ),
        ),
      ],
    );
  }
}

Future<List<dynamic>> loadSlots(List<dynamic> slots) async {
  var tempslots = await getSlot();
  slots = tempslots;
  return slots;
}

bool parsing(DateTime date, List<dynamic> slots) {
  for (var slot in slots) {
    if ((slot['start_date'] * 1000) == date.millisecondsSinceEpoch) {
      return false;
    }
  }
  return true;
}

class SlotAdd extends StatefulWidget {
  final List<dynamic> tempslot;
  const SlotAdd({super.key, required this.tempslot});

  @override
  State<SlotAdd> createState() => _SlotAddState();
}

class _SlotAddState extends State<SlotAdd> {
  DateTime date = DateTime.now();
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;
  int hour = DateTime.now().hour;
  int minute = 0;

  String dropdownvalue = DateTime.now().hour.toString().length == 1
      ? "0${DateTime.now().hour + 1}:00"
      : "${DateTime.now().hour}:00";
  List<String> list = [
    '00:00',
    '00:30',
    '01:00',
    '01:30',
    '02:00',
    '02:30',
    '03:00',
    '03:30',
    '04:00',
    '04:30',
    '05:00',
    '05:30',
    '06:00',
    '06:30',
    '07:00',
    '07:30',
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
    '18:30',
    '19:00',
    '19:30',
    '20:00',
    '20:30',
    '21:00',
    '21:30',
    '22:00',
    '22:30',
    '23:00',
    '23:30'
  ];

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ouvrez un créneau",
      subtitle: "Séléctionner une date pour ouvrir un créneau",
      body: [
        const Text(
          "Date du créneau",
          style: TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 4,
        ),
        CustomDatePiker(
            value: DateFormat("yMd", "fr").format(date),
            startDate: DateTime.now(),
            onChanged: (value) {
              setState(() {
                if (value.length == 10 && value[2] == '/' && value[5] == '/') {
                  year = int.parse(value.substring(6));
                  month = int.parse(value.substring(3, 5));
                  day = int.parse(value.substring(0, 2));
                  date = DateTime(year, month, day);
                } else {}
              });
            }),
        const SizedBox(
          height: 12,
        ),
        const Text(
          "Heure du créneau",
          style: TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 4,
        ),
        CustomDropdownButton(
          list: list,
          dropdownvalue: dropdownvalue,
          onChanged: (value) {
            dropdownvalue = value!;
            hour = int.parse(value.substring(0, 2));
            minute = int.parse(value.substring(3, 5));
          },
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.orange100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.orange300, width: 2),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  BootstrapIcons.exclamation_diamond_fill,
                  color: AppColors.orange600,
                  size: 32,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    "En ouvrant ce créneau, n'importe quel patient pourra le réserver",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Revenir en arrière'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.validate,
              size: SizeButton.sm,
              msg: const Text('Ouvrir le créneau'),
              onPressed: () {
                date = DateTime(year, month, day, hour, minute, 0);
                if (parsing(date, widget.tempslot) == true) {
                  postSlot(date);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/dashboard');
                  ScaffoldMessenger.of(context).showSnackBar(SuccessSnackBar(
                    message: 'Créneau créé avec succès',
                    context: context,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                    message: 'Créneau déjà existant',
                    context: context,
                  ));
                }
              },
            ),
          ),
        ],
      ),
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.check_circle_fill,
          color: AppColors.green700,
          size: 18,
        ),
        type: ModalType.success,
      ),
    );
  }
}
