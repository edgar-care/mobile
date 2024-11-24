// ignore_for_file: use_build_context_synchronously, duplicate_ignore
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/services/get_information_patient.dart';
import 'package:edgar_app/services/medical_antecedent.dart';
import 'package:edgar_app/utils/treatement_utils.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_docteur.dart';
import 'package:edgar_app/widget/card_traitement_small.dart';
import 'package:edgar_app/widget/modal_treatment.dart';
import 'package:edgar_app/widget/navbarplus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class InformationPersonnel extends StatefulWidget {
  const InformationPersonnel({super.key});

  @override
  State<InformationPersonnel> createState() => _InformationPersonnelState();
}

class _InformationPersonnelState extends State<InformationPersonnel>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic> infoMedical = {};
  Map<String, dynamic> tmpInfo = {};
  List<Map<String, dynamic>> tmpTraitments = [];
  String birthdate = '';
  String doctorName = '';
  var pageIndex = ValueNotifier(0);

  Future<void> fetchData() async {
    await getMedicalFolder(context).then((value) {
      if (value.isNotEmpty) {
        List<Map<String, dynamic>>medicalAntecedent = [];
        List<Treatment> tmpTraitments = [];
        for (var element in value['medical_antecedents']) {
          if (element['name'] != "" && element['id'] != "" && element['treatments'] != []) {
            for (var treatment in element['treatments']) {
              tmpTraitments.add(Treatment.fromJson(treatment));
            }
            medicalAntecedent.add({
              "name": element['name'],
              "id": element['id'],
              "treatments": tmpTraitments
          }); 
          }
        }
        infoMedical = {
          ...value,
          "medical_antecedents": medicalAntecedent
        };
        birthdate = DateFormat('dd/MM/yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
                infoMedical['birthdate'] * 1000));
      } else {
        TopErrorSnackBar(message: "Error on fetching name").show(context);
      }
    });
    doctorName = await getNameDoctor();
  }
  Future<String> getNameDoctor() async {
    try {
      final value = await getAllDoctor(context);
      if (value.isNotEmpty) {
        for (var doctor in value) {
          if (doctor['id'] == infoMedical['primary_doctor_id']) {
            if (doctor['name'] != null) {
              return 'Dr. ${doctor['firstname']} ${doctor['name'].toUpperCase()}';
            } else {
              return 'Dr.Edgar';
            }
          }
        }
      } else {
        TopErrorSnackBar(message: "Error on fetching doctor").show(context);
        return 'test';
      }
    } catch (e) {
      TopErrorSnackBar(message: "Error on fetching doctor").show(context);
      return 'test';
    }
    return 'Dr.Edgar'; // default return value if no doctor matches
  }

  void refresh(){
    setState(() {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.blue700,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo/edgar-high-five.png',
                width: 40,
              ),
              const SizedBox(width: 16),
              const Text(
                'Dossier Médical',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.blue700,
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              Logger().d(snapshot.error);
              return const Center(
                child: Text('Erreur lors du chargement des données'),
              );
            } else {
              return Expanded(
                child: CardInformationPersonnel(
                  refresh: refresh,
                    infoMedical: infoMedical,
                    birthdate: birthdate,
                    doctorName: doctorName),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        Buttons(
          variant: Variant.primary,
          size: SizeButton.md,
          msg: const Text('Modifier les informations'),
          onPressed: () {
            pageIndex.value = 0;
            final model = Provider.of<BottomSheetModel>(context, listen: false);
            model.resetCurrentIndex();
            tmpInfo = Map.of(infoMedical);
            // selected.value = infoMedical["sex"];
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Consumer<BottomSheetModel>(
                  builder: (context, model, child) {
                    return ListModal(
                      model: model,
                      children: [
                        AddSubMenu(tmpInfo: tmpInfo, refresh: () {
                          setState(() {
                            fetchData();
                          });
                        }),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class AddSubMenu extends StatelessWidget {
  Map<String, dynamic> tmpInfo;
  final Function refresh;
  AddSubMenu({super.key, required this.tmpInfo, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      body: [
        Text(
          "Ajouter un sujet de santé",
          style: const TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          type: "Only",
          title: 'Ajouter un sujet de santé',
          icon: const Icon(
            BootstrapIcons.bandaid_fill,
            color: AppColors.blue800,
            size: 16,
          ),
          onTap: () {
            final model = Provider.of<BottomSheetModel>(context, listen: false);
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
                      children: [
                          ModalTreamentInfo(
                            addMedicalAntecedents: (String antecedentName, List<Treatment> traitement) {
                              var antecedent = {
                                "name": antecedentName,
                                "symptoms": [],
                                "treatments": traitement.map((e) => e.toJson()).toList()
                              };
                              postMedicalAntecedent(antecedent, context);
                            },
                          )
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          type: "Only",
          title: 'Modifier mes informations',
          icon: const Icon(
            BootstrapIcons.postcard_heart_fill,
            color: AppColors.blue800,
            size: 16,
          ),
          onTap: () {
            Navigator.pop(context);
            final model = Provider.of<BottomSheetModel>(context, listen: false);
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
                      children: [
                        PatientAdd(
                          model: model,
                          info: tmpInfo),
                        PatientAdd2(
                          refresh: refresh,
                          model: model,
                          context: context,
                          tmpInfo: tmpInfo,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class CardInformationPersonnel extends StatefulWidget {
  final String birthdate;
  final Map<String, dynamic> infoMedical;
  final String doctorName;
  final Function refresh;
  const CardInformationPersonnel(
      {super.key,
      required this.infoMedical,
      required this.refresh,
      required this.birthdate,
      required this.doctorName});

  @override
  State<CardInformationPersonnel> createState() =>
      _CardInformationPersonnelState();
}

class _CardInformationPersonnelState extends State<CardInformationPersonnel> {


  @override
  Widget build(BuildContext context) {
  List<Map<String, dynamic>> medicalAntecedents = widget.infoMedical['medical_antecedents'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue200,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElementInfo(
              title: 'Prénom: ',
              value: widget.infoMedical['firstname'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Nom: ',
              value: widget.infoMedical['name'],
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Date de naissance: ',
              value: widget.birthdate,
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Sexe: ',
              value: widget.infoMedical['sex'] == 'MALE'
                  ? 'Homme'
                  : widget.infoMedical['sex'] == 'FEMALE'
                      ? 'Femme'
                      : 'Autres',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Taille: ',
              value: '${widget.infoMedical['height'] / 100} m',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Poids: ',
              value: '${widget.infoMedical['weight'] / 100} kg',
            ),
            const SizedBox(height: 8),
            ElementInfo(
              title: 'Médecin traitant: ',
              value: widget.doctorName,
            ),
            const SizedBox(height: 8),
            const Text(
              'Antécédants médicaux et sujets de santé:',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 4,
              runSpacing: 4,
              children: [
                if (medicalAntecedents.isNotEmpty)
                  for (var i = 0; i < medicalAntecedents.length; i++)
                    if (i < 3)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return IntrinsicWidth(
                            child: GestureDetector(
                              onTap: () {
                                if (medicalAntecedents.isNotEmpty) {
                                  final model =
                                      Provider.of<BottomSheetModel>(
                                          context,
                                          listen: false);
                                  model.resetCurrentIndex();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor:
                                        Colors.transparent,
                                    builder: (context) {
                                      return Consumer<
                                          BottomSheetModel>(
                                        builder: (context, model,
                                            child) {
                                          return ListModal(
                                            model: model,
                                            children: [
                                              SubMenuMedicalFolder(medicalAntecedent: medicalAntecedents[i],
                                                deleteAntecedent: (){
                                                  setState(() {
                                                    deleteMedicalAntecedent(medicalAntecedents[i]["id"], context);
                                                  });
                                                },
                                                refresh: (){
                                                  widget.refresh();
                                                },
                                              ),                                                         
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              child: CardTraitementSmall(
                                name: medicalAntecedents[i]['name'],
                                isEnCours: medicalAntecedents[i]
                                            ['treatments']
                                        .isEmpty
                                    ? false
                                    : true,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ElementInfo extends StatelessWidget {
  final String title;
  final String value;
  const ElementInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SubMenuMedicalFolder extends StatelessWidget {
  Map<String, dynamic> medicalAntecedent;
  final Function deleteAntecedent;
  final Function refresh;
  SubMenuMedicalFolder({super.key, required this.medicalAntecedent, required this.deleteAntecedent, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      body: [
        Text(
          medicalAntecedent['name'],
          style: const TextStyle(
              fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          title: 'Consulter les traitements',
          onTap: () {
            final model =
              Provider.of<BottomSheetModel>(
                  context,
                  listen: false);
            model.resetCurrentIndex();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent,
              builder: (context) {
                return Consumer<
                    BottomSheetModel>(
                  builder: (context, model,
                      child) {
                    return ListModal(
                      model: model,
                      children: [
                        ModalInfoAntecedent(medicalAntecedent: medicalAntecedent)                                       
                      ],
                    );
                  },
                );
              },
            );
          },
          type: 'Only',
          icon: const Icon(
            BootstrapIcons.bandaid_fill,
            color: AppColors.blue800,
            size: 16,
          ),
        ),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          icon: const Icon(
            BootstrapIcons.pen_fill,
            color: AppColors.blue800,
            size: 16,
          ),
          title: "Modifier mon sujet de santé",
          onTap: () {
            final model =
              Provider.of<BottomSheetModel>(
                  context,
                  listen: false);
            model.resetCurrentIndex();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent,
              builder: (context) {
                return Consumer<
                    BottomSheetModel>(
                  builder: (context, model,
                      child) {
                    return ListModal(
                      model: model,
                      children: [
                        UpdateAntecedentNameModal(startName: medicalAntecedent['name'], id: medicalAntecedent['id'], refresh: refresh,)
                      ],
                    );
                  },
                );
              },
            );
          },
          type: "Only"
        ),
        Container(
          color: AppColors.blue100,
          height: 1,
        ),
        NavbarPLusTab(
          title: 'Supprimer mon sujet de santé',
          color: AppColors.red700,
          onTap: () {
            final model =
              Provider.of<BottomSheetModel>(
                  context,
                  listen: false);
            model.resetCurrentIndex();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor:
                  Colors.transparent,
              builder: (context) {
                return Consumer<
                    BottomSheetModel>(
                  builder: (context, model,
                      child) {
                    return ListModal(
                      model: model,
                      children: [
                        DeleteAntecedentModal(
                          deleteAntecedent: deleteAntecedent,
                          refresh: refresh,
                          antecedentName: medicalAntecedent['name'],
                        )
                      ],
                    );
                  },
                );
              },
            );
          },
          type: 'Only',
          icon: const Icon(
            BootstrapIcons.trash_fill,
            color: AppColors.red700,
            size: 16,
          ),
        ),
      ],
    );
  }
}

class UpdateAntecedentNameModal extends StatelessWidget {
  final Function refresh;
  final String id;
  final String startName;
  const UpdateAntecedentNameModal({super.key, required this.startName, required this.id, required this.refresh});

  @override
  Widget build(BuildContext context) {
    String antecedentName = startName;
    return ModalContainer(
      icon: IconModal(
        icon: Icon(
          BootstrapIcons.capsule_pill,
          color: AppColors.blue700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      title: "Modifier un sujet de santé",
      subtitle: "Renseigner les informations de votre sujet de santé.",
      body: [
        Text("Le nom du votre sujet de santé", style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        )),
        const SizedBox(height: 4,),
        CustomField(
          label: "Nom du sujet de santé",
          value: antecedentName,
          onChanged: (value) {
            antecedentName = value;
          },
          isPassword: false,
          keyboardType: TextInputType.text,
          action: TextInputAction.done,
        ),
      ],
      footer: Column(
        children: [
          Buttons(
            variant: Variant.primary,
            size: SizeButton.sm,
            msg: const Text('Modifier le sujet de santé'),
            onPressed: () {
              if (antecedentName != "") {
                putMedicalAntecedent(
                  {
                    "medical_antecedent":{
                      "name": antecedentName,
                      "symptoms": [],
                    }
                  }, id, 
                context).then((value) {
                  if (value) {
                    TopSuccessSnackBar(
                      message: "Sujet de santé modifié avec succès",
                    ).show(context);
                    refresh();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else {
                    TopErrorSnackBar(
                      message: "Erreur lors de la modification du sujet de santé",
                    ).show(context);
                  }
                });
              }else{
                TopErrorSnackBar(
                  message: "Veuillez remplir tous les champs",
                ).show(context);
              }
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.sm,
            msg: const Text("Annuler"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }
}

class DeleteAntecedentModal extends StatelessWidget {
  final Function deleteAntecedent;
  final Function refresh;
  final String antecedentName;
  const DeleteAntecedentModal({super.key, required this.deleteAntecedent, required this.refresh, required this.antecedentName});

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Supprimer un sujet de santé",
      subtitle: "Vous êtes sur le point de supprimer votre sujet de santé: $antecedentName. Si vous supprimez ce sujet de santé, vous ne pourrez plus le consulter.",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.x,
          color: AppColors.red700,
          size: 18,
        ),
        type: ModalType.error,
      ),
      footer: Column(
        children: [
          Buttons(
            variant: Variant.delete,
            size: SizeButton.sm,
            msg: const Text('Oui, supprimer le sujet de santé'),
            onPressed: () {
              deleteAntecedent();
              refresh();
              TopSuccessSnackBar(
                message: "Sujet de santé supprimé avec succès",
              ).show(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Buttons(
            variant: Variant.secondary,
            size: SizeButton.sm,
            msg: const Text("Non, garder le sujet de santé"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PatientAdd extends StatefulWidget {
  Map<String, dynamic> info;
  BottomSheetModel model;
  PatientAdd({super.key, required this.info, required this.model});

  @override
  State<PatientAdd> createState() => _PatientAddState();
}

class _PatientAddState extends State<PatientAdd> {

  ValueNotifier<int> selected = ValueNotifier(0);

  void updateSelection(int newSelection) {
    selected.value = newSelection;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Mise à jout des informations",
      subtitle: "Mettez à jour les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Annuler'),
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
              variant: Variant.primary,
              size: SizeButton.sm,
              msg: const Text('Continuer'),
              onPressed: () {
                if (widget.info['name'] == "" ||
                    widget.info['firstname'] == "" ||
                    widget.info['birthdate'] == "" ||
                    widget.info['weight'] == "" ||
                    widget.info['height'] == "") {
                  TopErrorSnackBar(
                    message: "Veuillez remplir tous les champs",
                  ).show(context);
                } else {
                  switch (selected.value) {
                    case 0:
                      widget.info['sex'] = "MALE";
                      break;
                    case 1:
                      widget.info['sex'] = "FEMALE";
                      break;
                    case 2:
                      widget.info['sex'] = "OTHER";
                      break;
                    default:
                  }
                  widget.model.changePage(1);
                }
              },
            ),
          ),
        ],
      ),
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue700,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue200,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Prénom",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomField(
              label: "Prénom",
              value: widget.info['firstname'],
              onChanged: (value) => widget.info['firstname'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
              action: TextInputAction.next,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Nom",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomField(
              label: "Nom",
              value: widget.info['name'],
              onChanged: (value) => widget.info['name'] = value,
              isPassword: false,
              keyboardType: TextInputType.text,
              action: TextInputAction.next,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Date de naissance",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 4,
            ),
            CustomDatePiker(
              onChanged: (value) {
                String day = value.substring(0, 2);
                String month = value.substring(3, 5);
                String year = value.substring(6, 10);
                int date = DateTime.parse('$year-$month-$day')
                        .millisecondsSinceEpoch ~/
                    1000;
                widget.info['birthdate'] = date;
              },
              endDate: DateTime.now(),
              initialValue: DateFormat('dd/MM/yyyy')
                  .format(
                    DateTime.fromMillisecondsSinceEpoch(
                        widget.info['birthdate'] * 1000),
                  )
                  .toString(),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Sexe",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            ValueListenableBuilder<int>(
              valueListenable: selected,
              builder: (context, value, child) {
                return Row(
                  children: [
                    AddButton(
                        onTap: () => updateSelection(0),
                        label: "Masculin",
                        color:
                            value == 0 ? AppColors.blue700 : AppColors.white),
                    const SizedBox(
                      width: 8,
                    ),
                    AddButton(
                        onTap: () => updateSelection(1),
                        label: "Féminin",
                        color:
                            value == 1 ? AppColors.blue700 : AppColors.white),
                    const SizedBox(
                      width: 8,
                    ),
                    AddButton(
                        onTap: () => updateSelection(2),
                        label: "Autre",
                        color:
                            value == 2 ? AppColors.blue700 : AppColors.white),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Taille",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomField(
                        label: "1,52m",
                        value: (widget.info['height']).toString(),
                        onChanged: (value) => widget.info['height'] =
                            (int.parse(value.replaceAll(',', '.')) * 100),
                        keyboardType: TextInputType.number,
                        isPassword: false,
                        action: TextInputAction.next,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Poids",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomField(
                        label: "45kg",
                        value: (widget.info['weight'] ~/ 100).toString(),
                        onChanged: (value) => widget.info['weight'] =
                            int.parse(value.replaceAll(',', '.')) * 100,
                        keyboardType: TextInputType.number,
                        isPassword: false,
                        action: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class PatientAdd2 extends StatefulWidget {
  final BottomSheetModel model;
  final BuildContext context;
  final Map<String, dynamic> tmpInfo;
  final Function refresh;

  const PatientAdd2({
    super.key,
    required this.model,
    required this.context,
    required this.tmpInfo,
    required this.refresh,
  });

  @override
  PatientAdd2State createState() => PatientAdd2State();
}

class PatientAdd2State extends State<PatientAdd2> {
  int selectedDoctor = -1;
  List<dynamic> docs = [];
  Future? _fetchDocsFuture;
  String nameFilter = "";

  @override
  void initState() {
    super.initState();
    _fetchDocsFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    var tmp = await getAllDoctor(context);
    setState(() {
      docs = tmp;
    });
    if (widget.tmpInfo['medecin_traitant'] != "") {
      updateSelectedDoctor(docs.indexWhere(
          (doc) => doc['id'] == widget.tmpInfo['medecin_traitant']));
    }
    return docs;
  }

  void updateSelectedDoctor(int index) {
    setState(() {
      selectedDoctor = index;
    });
  }

  int getDoctor() {
    return selectedDoctor;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Mise à jout des informations",
      subtitle: "Mettez à jour les informations du patient",
      icon: const IconModal(
        icon: Icon(
          BootstrapIcons.postcard_heart_fill,
          color: AppColors.grey700,
          size: 18,
        ),
        type: ModalType.info,
      ),
      footer: Row(
        children: [
          Flexible(
            child: Buttons(
              variant: Variant.secondary,
              size: SizeButton.sm,
              msg: const Text('Précedent'),
              onPressed: () {
                widget.model.changePage(0);
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(
            child: Buttons(
              variant: Variant.primary,
              size: SizeButton.sm,
              msg: const Text('Valider'),
              onPressed: () {
                if (getDoctor() != -1) {
                  List<Map<String, dynamic>>medicaljson = [];
                  for (var element in widget.tmpInfo['medical_antecedents']) {
                    medicaljson.add({
                       "name" : element['name'],
                      "symptoms" : element['symptoms'],
                      "treatments" : element['treatments'].map((treatment) => treatment.toJson()).toList()
                    });
                  }
                  final Map<String, Object> body = {
                  "name": widget.tmpInfo['name'],
                  "firstname": widget.tmpInfo['firstname'],
                  "birthdate": widget.tmpInfo['birthdate'],
                  "sex": widget.tmpInfo['sex'],
                  "weight": widget.tmpInfo['weight'],
                  "height": widget.tmpInfo['height'],
                  "primary_doctor_id": widget.tmpInfo['primary_doctor_id'],
                  "family_members_med_info_id":
                      widget.tmpInfo['family_members_med_info_id'],
                  "medical_antecedents": medicaljson,
                  "onboarding_status": "DONE",
                };
                putInformationPatient(context, body, widget.tmpInfo['id']).then(
                  (value) => {
                    if (value != null)
                      {
                        TopSuccessSnackBar(
                          message: "Informations mises à jour avec succès",
                        ).show(context),
                        Navigator.pop(context),
                        widget.refresh(),
                      }
                      else
                        {
                          TopErrorSnackBar(
                            message: "Erreur lors de la mise à jour des informations",
                          ).show(context),
                        }
                  },
                );
                } else {
                  TopErrorSnackBar(
                    message: "Veuillez selectionner un médecin traitant",
                  ).show(context);
                }
              },
            ),
          ),
        ],
      ),
      body: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue700,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Container(
                height: 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.blue700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Nom du médecin traitant',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 8),
        CustomFieldSearch(
          label: 'Docteur Edgar',
          icon: SvgPicture.asset("assets/images/utils/search.svg"),
          keyboardType: TextInputType.name,
          onValidate: (value) {
            setState(() {
              nameFilter = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder(
            future: _fetchDocsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text("Erreur lors du chargement des données"));
              } else if (snapshot.hasData) {
                // Filtrer les docs basés sur nameFilter
                var filteredDocs = docs.where((doc) {
                  return doc['name']
                      .toLowerCase()
                      .contains(nameFilter.toLowerCase());
                }).toList();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var doc = filteredDocs[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return CardDoctor(
                            name: doc['name'] == ""
                                ? "Docteur Edgar"
                                : "Docteur ${doc['name']}",
                            street: doc['address']['street'] == ""
                                ? "1 rue de la paix"
                                : doc['address']['street'],
                            city: doc['address']['city'] == ""
                                ? "Paris"
                                : doc['address']['city'],
                            zipCode: doc['address']['zip_code'] == ""
                                ? "75000"
                                : doc['address']['zip_code'],
                            selected: index == getDoctor() ? true : false,
                            onclick: () {
                              setState(() {
                                if (getDoctor() == index) {
                                  updateSelectedDoctor(-1);
                                  widget.tmpInfo['primary_doctor_id'] = "";
                                } else {
                                  updateSelectedDoctor(index);
                                }
                                if (getDoctor() != -1) {
                                  widget.tmpInfo['primary_doctor_id'] =
                                      doc['id'];
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Aucune donnée disponible"));
              }
            },
          ),
        ),
      ],
    );
  }
}