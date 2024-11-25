class Medicine {
  String medicineId;
  int qsp;
  String qspUnit;
  String comment;
  List<Period> periods;
  Medicine({
    required this.medicineId,
    required this.qsp,
    required this.qspUnit,
    required this.comment,
    required this.periods,
  });
}

class Period {
  int quantity;
  int frequency;
  int frequencyRatio;
  String frequencyUnit;
  int periodLength;
  String periodUnit;

  Period({
    required this.quantity,
    required this.frequency,
    required this.frequencyRatio,
    required this.frequencyUnit,
    required this.periodLength,
    required this.periodUnit,
  });
}
