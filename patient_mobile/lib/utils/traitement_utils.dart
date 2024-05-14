import 'package:intl/intl.dart';

class Hour {
  final String hour;
  final String id;

  Hour({
    required this.hour,
    required this.id,
  });
}

class DayHour {
  final String day;
  final List<Hour> hour;

  DayHour({
    required this.day,
    required this.hour,
  });
}

class Appointment {
  final String doctor;
  final Address address;
  final List<DayHour> dates;

  Appointment({
    required this.doctor,
    required this.address,
    required this.dates,
  });
}

class Address {
  final String street;
  final String zipCode;
  final String country;
  final String city;

  Address({
    required this.street,
    required this.zipCode,
    required this.country,
    required this.city,
  });
}

class Doctor {
  final String id;
  final String firstname;
  final String name;
  final Address address;

  Doctor({
    required this.id,
    required this.firstname,
    required this.name,
    required this.address,
  });
}

Appointment _extractDayHour(Appointment appointment,
    Map<String, dynamic> appointmentData, Address address, String doctor) {
  String startDateString = appointmentData['start_date'].toString();
  DateFormat dayFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('HH:mm');
  String startDay = dayFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(startDateString) * 1000));
  String startHour = timeFormat.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(startDateString) * 1000));

  appointment.dates.where((element) => element.day == startDay).isEmpty
      ? appointment.dates.add(DayHour(
          day: startDay,
          hour: [Hour(hour: startHour, id: appointmentData['id'])]))
      : appointment.dates
          .where((element) => element.day == startDay)
          .first
          .hour
          .add(Hour(hour: startHour, id: appointmentData['id']));

  return appointment;
}

// Main function to transform appointments
Appointment? transformAppointments(
  List<dynamic> doctorsData,
  Map<String, dynamic> appointmentData,
) {
  if (appointmentData.isEmpty ||
      appointmentData['rdv'] == null ||
      appointmentData['rdv'].isEmpty) {
    return null;
  }

  String doctorId = appointmentData['rdv'][0]['doctor_id'];

  final Doctor? doctor = findDoctorById(doctorsData, doctorId);
  Appointment appointment = Appointment(
    doctor: doctor!.name,
    address: doctor.address,
    dates: [],
  );

  for (Map<String, dynamic> tmp in appointmentData['rdv']) {
    String appointmentStatus = tmp['appointment_status'];

    if (doctorId.isNotEmpty && appointmentStatus == 'OPENED') {
      appointment = _extractDayHour(appointment, tmp, doctor.address,
          '${doctor.firstname} ${doctor.name}');
    }
  }

  if (appointment.dates.isEmpty) {
    return null;
  }

  return appointment;
}

Doctor? findDoctorById(List<dynamic> doctorsData, String doctorId) {
  for (Map<String, dynamic> doctorMap in doctorsData) {
    String id = doctorMap['id'];
    if (id == doctorId) {
      String firstname = doctorMap['firstname'] ?? "Test";
      String name = doctorMap['name'] ?? "Edgar";
      Address address = Address(
        street: doctorMap['address']['street'] ?? '1 rue de la Paix',
        zipCode: doctorMap['address']['zip_code'] ?? '69000',
        country: doctorMap['address']['country'] ?? 'France',
        city: doctorMap['address']['city'] ?? 'Lyon',
      );
      return Doctor(id: id, firstname: firstname, name: name, address: address);
    }
  }
  return null; // Doctor not found
}

List<Map<String, dynamic>> extractAppointmentDatesWithHours(
    List<Map<String, dynamic>>? datesList) {
  List<Map<String, dynamic>> formattedDates = [];

  if (datesList == null || datesList.isEmpty) {
    return formattedDates; // Return empty list if datesList is null or empty
  }

  for (Map<String, dynamic> dateMap in datesList) {
    String startDateString = dateMap['start_date'].toString();
    DateFormat dayFormat = DateFormat('dd/MM/yyyy');
    DateFormat timeFormat = DateFormat('HH:mm');
    String startDay = dayFormat.format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(startDateString) * 1000));
    List<String> formattedHours = [];

    for (String hourString
        in dateMap.containsKey('hours') ? dateMap['hours'] : []) {
      formattedHours.add(timeFormat.format(DateTime.parse(hourString)));
    }

    formattedDates.add({
      'day': startDay,
      'hour': formattedHours,
    });
  }

  return formattedDates;
}
