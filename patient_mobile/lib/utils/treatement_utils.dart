// ignore: constant_identifier_names
enum FrequencyUnit { JOUR, SEMAINE, MOIS, ANNEE }

// ignore: constant_identifier_names
enum PeriodUnit { JOUR, SEMAINE, MOIS, ANNEE }

class Treatment {
  String id;
  DateTime startDate;
  DateTime endDate;
  List<Medicine> medicines;

  Treatment({
    this.id = "0",
    required this.startDate,
    required this.endDate,
    required this.medicines,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      startDate: DateTime.fromMillisecondsSinceEpoch(json['start_date'] * 1000),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['end_date'] * 1000),
      medicines:
          (json['medicines'] as List).map((x) => Medicine.fromJson(x)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'start_date': startDate,
        'end_date': endDate,
        'medicines': medicines.map((x) => x.toJson()).toList(),
      };
}

class Medicine {
  String medicineId;
  String comment;
  List<Period> period;

  Medicine({
    required this.medicineId,
    required this.comment,
    required this.period,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineId: json['medicine_id'],
      comment: json['comment'],
      period: (json['period'] as List).map((x) => Period.fromJson(x)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'medicine_id': medicineId,
        'comment': comment,
        'period': period.map((x) => x.toJson()).toList(),
      };
}

class Period {
  int quantity;
  int frequency;
  int frequencyRatio;
  FrequencyUnit frequencyUnit;
  int? periodLength;
  PeriodUnit? periodUnit;

  Period({
    required this.quantity,
    required this.frequency,
    required this.frequencyRatio,
    required this.frequencyUnit,
    this.periodLength,
    this.periodUnit,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    if (json['period_unit'] == null || json['period_length'] == "") {
      return Period(
        quantity: json['quantity'],
        frequency: json['frequency'],
        frequencyRatio: json['frequency_ratio'],
        frequencyUnit: FrequencyUnit.values.byName(json['frequency_unit']),
      );
    }
    return Period(
      quantity: json['quantity'],
      frequency: json['frequency'],
      frequencyRatio: json['frequency_ratio'],
      frequencyUnit: FrequencyUnit.values.byName(json['frequency_unit']),
      periodLength: json['period_length'],
      periodUnit: PeriodUnit.values.byName(json['period_unit']),
    );
  }

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'frequency': frequency,
        'frequency_ratio': frequencyRatio,
        'frequency_unit': frequencyUnit.name,
        'period_length': periodLength,
        'period_unit': periodUnit?.name,
      };
}
