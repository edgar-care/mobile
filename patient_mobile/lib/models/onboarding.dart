import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:edgar_app/services/auth.dart';
import 'package:edgar_app/services/doctor.dart';
import 'package:edgar_app/services/medecine.dart';
import 'package:edgar_app/widget/AddPatient/add_button.dart';
import 'package:edgar_app/widget/card_traitement_day.dart';
import 'package:edgar_app/widget/card_traitement_small.dart';
import 'package:flutter/material.dart';
import 'package:edgar_app/widget/card_docteur.dart';
import 'package:flutter_svg/svg.dart';
import 'package:confetti/confetti.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:edgar/colors.dart';
import 'package:edgar/widget.dart';
import 'package:provider/provider.dart';

String name = "";
String lastname = "";
String birthdate = "";
String sexe = "MALE";
String height = "";
String weight = "";
String primaryDoctorId = "";
bool isHealths = false;

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late final List<Widget> pages;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    name = "";
    lastname = "";
    birthdate = "";
    sexe = "";
    height = "";
    weight = "";
    primaryDoctorId = "";
    isHealths = false;
  }

  _OnboardingState() {
    pages = [
      Onboarding1(
        updateSelectedIndex: updateSelectedIndex,
      ),
      Onboarding2(
        updateSelectedIndex: updateSelectedIndex,
        docteurs: const [],
      ),
      Onboarding3(
        updateSelectedIndex: updateSelectedIndex,
      ),
      const OnboardingFinish(),
    ];
  }

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildWarningBox() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.red200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.red400, width: 2),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      child: const Text(
        "Ce projet est uniquement destiné à des fins de démonstration. Ne pouvant garantir la sécurité et l'anonymisation de vos données de santé, nous vous demandons de ne pas saisir d'informations personnelles ou médicales sensibles.",
        style: TextStyle(
          color: AppColors.black,
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: const BoxDecoration(
                color: AppColors.blue700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(48),
                  bottomRight: Radius.circular(48),
                ),
              ),
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    SvgPicture.asset("assets/images/logo/edgar_staying.svg"),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'J’ai besoin de vos informations personnelles afin de remplir votre espace patient',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildWarningBox(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Onboarding1 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  const Onboarding1({required this.updateSelectedIndex, super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final ValueNotifier<String> _selected = ValueNotifier('MALE');
  final ValueNotifier<bool> _isHealth = ValueNotifier(false);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr', null);
  }

  @override
  void dispose() {
    _selected.dispose();
    _isHealth.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _birthdateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildProgressIndicator(),
              const SizedBox(height: 16),
              _buildInputField('Votre prénom', 'Edgar', _nameController),
              _buildInputField(
                  'Votre nom', "L'assistant numerique", _lastnameController),
              _buildDatePicker(),
              _buildGenderSelection(),
              _buildHeightWeightRow(),
              _buildHealthQuestion(),
              const SizedBox(height: 24),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.blue700,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.blue200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.blue200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        CustomField(
          label: hint,
          onChanged: (value) => controller.text = value,
          action: TextInputAction.next,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Votre date de naissance',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        CustomDatePiker(
          onChanged: (value) => _birthdateController.text = value,
          value: _birthdateController.text.isNotEmpty
              ? _birthdateController.text
              : null,
          placeHolder: "26/09/2022",
          endDate: DateTime.now(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Votre sexe',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String>(
          valueListenable: _selected,
          builder: (context, value, child) {
            return Row(
              children: [
                _buildGenderButton('MALE', 'Masculin', value),
                const SizedBox(width: 16),
                _buildGenderButton('FEMALE', 'Féminin', value),
                const SizedBox(width: 16),
                _buildGenderButton('OTHER', 'Autre', value),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGenderButton(String gender, String label, String selectedValue) {
    return AddButtonSpe(
      onTap: () => _selected.value = gender,
      label: label,
      background: selectedValue == gender ? AppColors.blue700 : AppColors.white,
      color: selectedValue == gender ? AppColors.white : AppColors.grey400,
    );
  }

  Widget _buildHeightWeightRow() {
    return Row(
      children: [
        Expanded(
          child: _buildInputField('Votre taille', '183cm', _heightController),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInputField('Votre poids', '75kg', _weightController),
        ),
      ],
    );
  }

  Widget _buildHealthQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avez-vous des antécédents médicaux ou sujets de santé ?',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: _isHealth,
          builder: (context, value, child) {
            return Row(
              children: [
                _buildHealthButton(true, 'Oui', value),
                const SizedBox(width: 16),
                _buildHealthButton(false, 'Non', value),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHealthButton(bool isYes, String label, bool currentValue) {
    return AddButtonSpeHealth(
      onTap: () => _isHealth.value = isYes,
      label: label,
      color: currentValue == isYes ? AppColors.white : AppColors.blue700,
      background: currentValue == isYes ? AppColors.blue700 : AppColors.white,
    );
  }

  Widget _buildContinueButton() {
    return Buttons(
      variant: Variant.primary,
      size: SizeButton.md,
      msg: const Text("Continuer"),
      onPressed: _validateAndContinue,
    );
  }

  void _validateAndContinue() {
    if (_nameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _birthdateController.text.isNotEmpty &&
        _heightController.text.isNotEmpty &&
        _weightController.text.isNotEmpty) {
      // Update global variables if needed
      name = _nameController.text.trim();
      lastname = _lastnameController.text.trim();
      birthdate = _birthdateController.text.trim();
      sexe = _selected.value;
      height = _heightController.text.trim();
      weight = _weightController.text.trim();
      isHealths = _isHealth.value;

      widget.updateSelectedIndex(1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        ErrorSnackBar(message: "Compléter tous les champs", context: context),
      );
    }
  }
}

class Onboarding2 extends StatefulWidget {
  final Function(int) updateSelectedIndex;
  final List<Map<String, dynamic>> docteurs;
  const Onboarding2(
      {required this.updateSelectedIndex, required this.docteurs, super.key});

  @override
  State<Onboarding2> createState() => _onboarding2State();
}

// ignore: camel_case_types
class _onboarding2State extends State<Onboarding2> {
  List<dynamic> docs = [];
  Future? _fetchDocsFuture;
  String nameFilter = "";

  @override
  void initState() {
    super.initState();
    _fetchDocsFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    var tmp = await getAllDoctor();
    setState(() {
      docs = tmp;
    });
    if (primaryDoctorId != "") {
      selectedDoctor = docs.indexWhere((doc) => doc['id'] == primaryDoctorId);
    }
    return docs;
  }

  int selectedDoctor = -1;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
          top: 16,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                      child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.blue700,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
                                selected:
                                    index == selectedDoctor ? true : false,
                                onclick: () {
                                  setState(() {
                                    if (selectedDoctor == index) {
                                      selectedDoctor = -1;
                                      primaryDoctorId = "";
                                    } else {
                                      selectedDoctor = index;
                                    }
                                    if (selectedDoctor != -1) {
                                      primaryDoctorId = doc['id'];
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
                    return const Center(
                        child: Text("Aucune donnée disponible"));
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Buttons(
                variant: Variant.primary,
                size: SizeButton.md,
                msg: const Text("Continuer"),
                onPressed: () async {
                  if (selectedDoctor != -1) {
                    if (isHealths == true) {
                      widget.updateSelectedIndex(2);
                    } else {
                      List<String> parts = birthdate.split('/');
                      String americanDate =
                          '${parts[2]}-${parts[1]}-${parts[0]}';
                      final birth = DateTime.parse(americanDate);
                      final integerDate =
                          (birth.millisecondsSinceEpoch / 1000).round();
                      final Map<String, Object> body = {
                        "name": name,
                        "firstName": lastname,
                        "birthdate": integerDate,
                        "sex": sexe,
                        "weight": int.parse(weight) * 100,
                        "height": int.parse(height),
                        "primary_doctor_id": primaryDoctorId,
                        "family_members_med_info_id": [],
                        "medical_antecedents": [],
                      };

                      // ignore: unused_local_variable
                      bool medicalinfo = await postMedicalInfo(body);
                      if (!medicalinfo) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                            ErrorSnackBar(
                                message:
                                    "Erreur lors de l'ajout des informations",
                                // ignore: use_build_context_synchronously
                                context: context));
                      }
                      widget.updateSelectedIndex(3);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message: "Selectionner un docteur", context: context));
                  }
                }),
            const SizedBox(height: 8),
            Buttons(
                variant: Variant.secondary,
                size: SizeButton.md,
                msg: const Text("Précédent"),
                onPressed: () {
                  widget.updateSelectedIndex(0);
                }),
          ],
        ),
      ),
    );
  }
}

class Onboarding3 extends StatefulWidget {
  final Function(int) updateSelectedIndex;

  const Onboarding3({
    super.key,
    required this.updateSelectedIndex,
  });

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0);

  void updateData(int index) {
    setState(() {
      pageIndex.value = index;
    });
  }

  List<Map<String, dynamic>> traitments = [];

  void addNewTraitement(
      String name, Map<String, dynamic> medicines, bool stillRelevant) async {
    setState(() {
      traitments.add({
        "Name": name,
        "treatments": medicines["treatments"],
        "still_relevant": stillRelevant,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 12,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Flexible(
                        child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.blue700,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.blue700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Vos antécédents médicaux et sujets de santé",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  final model =
                      Provider.of<BottomSheetModel>(context, listen: false);
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
                              AddTreatment(addNewTraitement: addNewTraitement)
                            ],
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue500, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Renseigner vos informations",
                        style: TextStyle(
                          color: AppColors.grey400,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/images/utils/plus-lg.svg",
                        // ignore: deprecated_member_use
                        color: AppColors.blue700,
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Vos antécédénts médicaux et sujets de santé renseignés",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.429,
                child: FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 0), () {
                    return true;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Expanded(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: AppColors.white,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erreur: ${snapshot.error}');
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            if (traitments.isNotEmpty)
                              for (var i = 0; i < traitments.length; i++)
                                if (i < 3)
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return IntrinsicWidth(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (traitments[i]['treatments']
                                                .isNotEmpty) {
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
                                                          InfoTreatment(
                                                              traitement:
                                                                  traitments[i])
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: CardTraitementSmall(
                                            name: traitments[i]['Name'],
                                            isEnCours: traitments[i]
                                                        ['treatments']
                                                    .isEmpty
                                                ? false
                                                : true,
                                            onTap: () {
                                              setState(() {
                                                traitments.removeAt(i);
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              Buttons(
                variant: Variant.validate,
                size: SizeButton.md,
                msg: const Text("Valider"),
                onPressed: () async {
                  if (traitments.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message: "Ajouter des informations", context: context));
                    return;
                  }
                  List<String> parts = birthdate.split('/');
                  String americanDate = '${parts[2]}-${parts[1]}-${parts[0]}';
                  final birth = DateTime.parse(americanDate);
                  final integerDate =
                      (birth.millisecondsSinceEpoch / 1000).round();

                  final Map<String, Object> body = {
                    "name": name,
                    "firstName": lastname,
                    "birthdate": integerDate,
                    "sex": sexe,
                    "weight": int.parse(weight) * 100,
                    "height": int.parse(height),
                    "primary_doctor_id": primaryDoctorId,
                    "family_members_med_info_id": [],
                    "medical_antecedents": traitments,
                  };

                  var reponse = await postMedicalInfo(body);
                  if (reponse == true) {
                    widget.updateSelectedIndex(3);
                  } else {}

                  widget.updateSelectedIndex(3);
                },
              ),
              const SizedBox(height: 8),
              Buttons(
                  variant: Variant.secondary,
                  size: SizeButton.md,
                  msg: const Text("Précédent"),
                  onPressed: () {
                    widget.updateSelectedIndex(1);
                  }),
            ],
          )),
    );
  }
}

class OnboardingFinish extends StatefulWidget {
  const OnboardingFinish({super.key});

  @override
  State<OnboardingFinish> createState() => _OnboardingFinishState();
}

class _OnboardingFinishState extends State<OnboardingFinish> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 172,
      child: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 24,
            top: 16,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    AppColors.blue400,
                    AppColors.blue500,
                    AppColors.blue600,
                    AppColors.blue700,
                    AppColors.blue800,
                    AppColors.blue900,
                    AppColors.green400,
                    AppColors.green500,
                    AppColors.green600,
                    AppColors.green700,
                    AppColors.green800,
                    AppColors.green900,
                  ], // manually specify the colors to be used
                  gravity: 0.8,
                  numberOfParticles: 16,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo/edgar-high-five.png',
                      width: 240,
                      height: 257,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Félicitations !',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Votre espace patient est maintenant créé',
                      style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    Buttons(
                        variant: Variant.primary,
                        size: SizeButton.md,
                        msg: const Text("Commencer"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/dashboard');
                        }),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class InfoTreatment extends StatefulWidget {
  Map<String, dynamic> traitement;
  InfoTreatment({super.key, required this.traitement});

  @override
  State<InfoTreatment> createState() => _InfoTreatmentState();
}

class _InfoTreatmentState extends State<InfoTreatment> {
  late Future<bool> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }

  List<Map<String, dynamic>> medicaments = [];

  List<String> medNames = [];

  Future<bool> fetchData() async {
    try {
      medicaments = await getMedecines();

      for (var i = 0; i < widget.traitement['treatments'].length; i++) {
        var medname = medicaments.firstWhere(
            (med) =>
                med['id'] == widget.traitement['treatments'][i]['medicine_id'],
            orElse: () => {'name': ''})['name'];
        medNames.add(medname);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isHealth =
        ValueNotifier(widget.traitement['still_relevant']);
    return ModalContainer(
      title: "widget.traitement['Name']",
      subtitle: "Information du traitement",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union.svg',
          width: 18,
          // ignore: deprecated_member_use
          color: widget.traitement['treatments'].isEmpty
              ? AppColors.grey300
              : AppColors.blue700,
        ),
        type: ModalType.info,
      ),
      body: [
        const Text(
          'Le sujet de santé est toujours en cours ?',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isHealth,
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {}),
                    label: "Oui",
                    color: value == true ? AppColors.blue700 : AppColors.white),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {}),
                    label: "Non",
                    color:
                        value == false ? AppColors.blue700 : AppColors.white),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Les médicaments prescrits',
          style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: FutureBuilder<bool>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: widget.traitement['treatments'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CardTraitementDay(
                              isClickable: false,
                              data: widget.traitement['treatments'][index],
                              name: medNames[index],
                              onTap: () {},
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }
}

class AddTreatment extends StatefulWidget {
  final Function addNewTraitement;
  const AddTreatment({super.key, required this.addNewTraitement});

  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

class _AddTreatmentState extends State<AddTreatment> {
  String name = "";
  bool stillRelevant = false;

  Map<String, dynamic> medicines = {"treatments": [], "name": "Parasetamole"};

  @override
  void initState() {
    super.initState();
    setState(() {
      medicines = {"treatments": [], "name": name};
    });
  }

  List<Map<String, dynamic>> medicaments = [];
  List<String> medNames = [];

  void updateMedicament(Map<String, dynamic> medicament) async {
    setState(() {
      medicines['treatments'].add(medicament);
    });
    fetchData();
  }

  Future<bool> fetchData() async {
    medicaments = await getMedecines();
    medNames.clear(); // Effacer la liste existante pour éviter les doublons

    for (var treatment in medicines['treatments']) {
      var medId = treatment['medicine_id'];
      var med = medicaments.firstWhere((med) => med['id'] == medId,
          orElse: () => {'name': ''});
      var medName = med['name'];
      medNames.add(medName);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajoutez un sujet de santé",
      subtitle: "Veuillez complétez tout les champs",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Subtract.svg',
          // ignore: deprecated_member_use
          color: AppColors.green700,
          width: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        const Text(
          'Nom de votre sujet de santé',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomField(
          label: 'Rhume',
          action: TextInputAction.next,
          onChanged: (value) {
            setState(() {
              name = value.trim();
            });
          },
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        const Text(
          'Le sujet de santé est-il toujours en cours ?',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: ValueNotifier(stillRelevant),
          builder: (context, value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AddButton(
                    onTap: (() {
                      setState(() {
                        stillRelevant = true;
                      });
                    }),
                    label: "Oui",
                    color:
                        value == true ? AppColors.blue700 : Colors.transparent),
                const SizedBox(width: 8),
                AddButton(
                    onTap: (() {
                      setState(() {
                        stillRelevant = false;
                      });
                    }),
                    label: "Non",
                    color: value == false
                        ? AppColors.blue700
                        : Colors.transparent),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
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
                        AddMedicament(updateMedicament: updateMedicament)
                      ],
                    );
                  },
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.blue500, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ajouter un médicament",
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  "assets/images/utils/plus-lg.svg",
                  // ignore: deprecated_member_use
                  color: AppColors.blue700,
                  width: 14,
                  height: 14,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: fetchData(), // Simulate some async operation
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: medicines['treatments'].length,
                  itemBuilder: (context, index) {
                    if (medicines['treatments'].isEmpty) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CardTraitementDay(
                        isClickable: true,
                        data: medicines['treatments'][index],
                        name: medNames[index],
                        onTap: () {
                          setState(() {
                            medicines['treatments'].removeAt(index);
                            medNames.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Buttons(
                variant: Variant.secondary,
                size: SizeButton.sm,
                msg: const Text("Annuler"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Buttons(
                variant: Variant.validate,
                size: SizeButton.sm,
                msg: const Text("Ajouter"),
                onPressed: () {
                  if (name == "") {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message: "Ajoutez un nom", context: context));
                    return;
                  }
                  widget.addNewTraitement(name, medicines, stillRelevant);
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class AddMedicament extends StatefulWidget {
  Function(Map<String, dynamic>) updateMedicament;
  AddMedicament({super.key, required this.updateMedicament});

  @override
  State<AddMedicament> createState() => _AddMedicamentState();
}

class _AddMedicamentState extends State<AddMedicament> {
  Map<String, dynamic> medicament = {
    "quantity": 0,
    "period": [],
    "day": [],
    "medicine_id": ""
  };

  List<Map<String, dynamic>> medicaments = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<String> nameMedic = [];

  Future<void> fetchData() async {
    medicaments = await getMedecines();
    for (var medicament in medicaments) {
      nameMedic.add(medicament['name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      title: "Ajouter un médicament",
      subtitle: "Veuillez compléter les champs",
      icon: IconModal(
        icon: SvgPicture.asset(
          'assets/images/utils/Union-lg.svg',
          // ignore: deprecated_member_use
          color: AppColors.green700,
          width: 18,
        ),
        type: ModalType.success,
      ),
      body: [
        const Text(
          'Nom de votre médicament',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomAutoComplete(
            label: 'Rechercher le nom du médicament ',
            icon: BootstrapIcons.search,
            keyboardType: TextInputType.name,
            onValidate: (value) {
              var selectedMedicament = medicaments.firstWhere(
                  (med) => med['name'] == value,
                  orElse: () => {'id': null});

              if (selectedMedicament['id'] != null) {
                setState(() {
                  medicament['medicine_id'] = selectedMedicament['id'];
                });
              } else {
                setState(() {
                  medicament['medicine_id'] = "";
                });
              }
            },
            suggestions: nameMedic),
        const SizedBox(height: 16),
        const Text(
          'Quantité de comprimés',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          child: CustomField(
            label: '1',
            action: TextInputAction.next,
            onChanged: (value) {
              setState(() {
                try {
                  medicament['quantity'] = int.parse(value);
                } catch (e) {
                  value = value.replaceAll(RegExp(r'[^0-9]'), '');
                  medicament['quantity'] = int.tryParse(value) ?? 0;
                }
              });
            },
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Jour de prise des médicaments',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('MONDAY')) {
                          medicament['day'].remove('MONDAY');
                        } else {
                          medicament['day'].add('MONDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('MONDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Lu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('TUESDAY')) {
                          medicament['day'].remove('TUESDAY');
                        } else {
                          medicament['day'].add('TUESDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('TUESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ma',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('WEDNESDAY')) {
                          medicament['day'].remove('WEDNESDAY');
                        } else {
                          medicament['day'].add('WEDNESDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('WEDNESDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Me',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('THURSDAY')) {
                          medicament['day'].remove('THURSDAY');
                        } else {
                          medicament['day'].add('THURSDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('THURSDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Je',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('FRIDAY')) {
                          medicament['day'].remove('FRIDAY');
                        } else {
                          medicament['day'].add('FRIDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('FRIDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Ve',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('SATURDAY')) {
                          medicament['day'].remove('SATURDAY');
                        } else {
                          medicament['day'].add('SATURDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SATURDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Sa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['day'].contains('SUNDAY')) {
                          medicament['day'].remove('SUNDAY');
                        } else {
                          medicament['day'].add('SUNDAY');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['day'].contains('SUNDAY')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Di',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Période de prise de la journée',
          style: TextStyle(
            color: AppColors.black,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('MORNING')) {
                          medicament['period'].remove('MORNING');
                        } else {
                          medicament['period'].add('MORNING');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('MORNING')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Matin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('NOON')) {
                          medicament['period'].remove('NOON');
                        } else {
                          medicament['period'].add('NOON');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('NOON')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Midi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('EVENING')) {
                          medicament['period'].remove('EVENING');
                        } else {
                          medicament['period'].add('EVENING');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('EVENING')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Soir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (medicament['period'].contains('NIGHT')) {
                          medicament['period'].remove('NIGHT');
                        } else {
                          medicament['period'].add('NIGHT');
                        }
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: medicament['period'].contains('NIGHT')
                            ? AppColors.blue700
                            : AppColors.grey300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('Nuit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
              ),
            ],
          ),
        ),
      ],
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Buttons(
                variant: Variant.secondary,
                size: SizeButton.sm,
                msg: const Text("Annuler"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Buttons(
                variant: Variant.validate,
                size: SizeButton.sm,
                msg: const Text("Ajouter"),
                onPressed: () {
                  if (medicament['medicine_id'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message:
                            "Veuillez choisir un médicament ou entrer un medicament valide",
                        context: context));
                    return;
                  }
                  if (medicament['quantity'] == 0 ||
                      medicament['day'].isEmpty ||
                      medicament['period'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
                        message: "Veuillez remplir tous les champs",
                        context: context));
                    return;
                  }
                  setState(() {
                    widget.updateMedicament(medicament);
                  });
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
