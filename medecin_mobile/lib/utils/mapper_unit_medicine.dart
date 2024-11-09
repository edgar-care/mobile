String convertMedicineUnit(String unit) {
  switch (unit) {
    case 'POMMADE':
      return 'Pommade';
    case 'GELULE':
      return 'Gélule';
    case 'COMPRIME':
      return 'Comprimé';
    case 'GELE':
      return 'Gel';
    case 'SOLUTION_BUVABLE':
      return 'Solution buvable';
    case 'POUDRE':
      return 'Poudre';
    case 'SUPPOSITOIRE':
      return 'Suppositoire';
    case 'AMPOULE':
      return 'Ampoule';
    case 'SUSPENSION_NASALE':
      return 'Suspension nasale';
    case 'SPRAY':
      return 'Spray';
    case 'COLLUTOIRE':
      return 'Collutoire';
    case 'SHAMPOOING':
      return 'Shampooing';
    case 'SOLUTION_INJECTABLE':
      return 'Solution injectable';
    case 'COMPRIMER_EFERVESCENT':
      return 'Comprimé effervescent';
    case 'GRANULER_EN_SACHET':
      return 'Granulé en sachet';
    case 'PASTILLE':
      return 'Pastille';
    case 'SIROP':
      return 'Sirop';
    default:
      return 'Comprimé';
  }
}

String convertMedicineUsageUnit(String unit) {
  switch (unit) {
    case 'POMMADE':
      return 'application';
    case 'GELULE':
      return 'gélule';
    case 'COMPRIME':
      return 'comprimé';
    case 'GELE':
      return 'application';
    case 'SOLUTION_BUVABLE':
      return 'dose';
    case 'POUDRE':
      return 'sachet';
    case 'SUPPOSITOIRE':
      return 'suppositoire';
    case 'AMPOULE':
      return 'ampoule';
    case 'SUSPENSION_NASALE':
      return 'utilisation nasale';
    case 'SPRAY':
      return 'utilisation';
    case 'COLLUTOIRE':
      return 'utilisation';
    case 'SHAMPOOING':
      return 'application';
    case 'SOLUTION_INJECTABLE':
      return 'solution injectable';
    case 'COMPRIMER_EFERVESCENT':
      return 'comprimé effervescent';
    case 'GRANULER_EN_SACHET':
      return 'sachet';
    case 'PASTILLE':
      return 'pastille';
    case 'SIROP':
      return 'dose';
    default:
      return 'application';
  }
}
