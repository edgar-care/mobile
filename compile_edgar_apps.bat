@echo off

REM Script d'exécution pour l'application Flutter edgar - Patient
cd patient_mobile
flutter pub get
flutter build apk --release
flutter run


REM Script d'exécution pour l'application Flutter edgar - Médecin
cd ..\medecin_mobile
flutter pub get
flutter build apk --release
flutter run
