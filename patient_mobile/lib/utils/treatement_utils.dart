// ignore: constant_identifier_names
enum FrequencyUnit { JOUR, SEMAINE, MOIS }

// ignore: constant_identifier_names
enum PeriodUnit { JOUR, SEMAINE, MOIS }

class Treatment {
  final String id;
  final String createdBy;
  final DateTime startDate;
  final DateTime endDate;
  final List<Medicine> medicines;

  Treatment({
    required this.id,
    required this.createdBy,
    required this.startDate,
    required this.endDate,
    required this.medicines,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      createdBy: json['created_by'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      medicines:
          (json['medicines'] as List).map((x) => Medicine.fromJson(x)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_by': createdBy,
        'start_date': startDate,
        'end_date': endDate,
        'medicines': medicines.map((x) => x.toJson()).toList(),
      };
}

class Medicine {
  final String medicineId;
  final String comment;
  final List<Period> period;

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
  final int quantity;
  final int frequency;
  final int frequencyRatio;
  final FrequencyUnit frequencyUnit;
  final int? periodLength;
  final PeriodUnit? periodUnit;

  Period({
    required this.quantity,
    required this.frequency,
    required this.frequencyRatio,
    required this.frequencyUnit,
    required this.periodLength,
    required this.periodUnit,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
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
