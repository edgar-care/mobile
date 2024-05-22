// ignore: constant_identifier_names
import 'package:logger/logger.dart';

enum Period { MORNING, NOON, EVENING, NIGHT }

// ignore: constant_identifier_names
enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

class Treatment {
  final String id;
  final List<Period> periods;
  final List<Day> days;
  final int quantity;
  final String medicineId;

  Treatment({
    required this.id,
    required this.periods,
    required this.days,
    required this.quantity,
    required this.medicineId,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? '',
      periods: (json['period'] as List)
          .map((period) => Period.values
              .firstWhere((e) => e.toString().split('.').last == period))
          .toList(),
      days: (json['day'] as List)
          .map((day) =>
              Day.values.firstWhere((e) => e.toString().split('.').last == day))
          .toList(),
      quantity: json['quantity'],
      medicineId: json['medicine_id'],
    );
  }
}

class Antedisease {
  final String id;
  final String name;
  final int chronicity;
  final bool stillRelevant;
  final List<Treatment>? treatments;

  Antedisease({
    required this.id,
    required this.name,
    required this.chronicity,
    required this.stillRelevant,
    required this.treatments,
  });

  factory Antedisease.fromJson(Map<String, dynamic> json) {
    return Antedisease(
      id: json["antedisease"]['id'],
      name: json["antedisease"]['name'],
      chronicity: json["antedisease"]['chronicity'],
      stillRelevant: json["antedisease"]['still_relevant'],
      treatments: json['treatments'] == null
          ? null
          : (json['treatments'] as List)
              .map((treatment) => Treatment.fromJson(treatment))
              .toList(),
    );
  }
}

Future<List<Treatment>> getTreatmentsByDayAndPeriod(
    List<dynamic> allTreatments, Day day, Period period) async {
  List<Antedisease> antediseases =
      allTreatments.map((e) => Antedisease.fromJson(e)).toList();
  List<Treatment> filteredTreatments = [];

  for (var antedisease in antediseases) {
    if (antedisease.treatments == null || !antedisease.stillRelevant) {
      continue;
    }
    for (var treatment in antedisease.treatments!) {
      if (treatment.days.contains(day) && treatment.periods.contains(period)) {
        filteredTreatments.add(treatment);
      }
    }
  }

  return filteredTreatments;
}
