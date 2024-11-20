String convertMedicineUnit(String unit) {
  switch (unit) {
    case 'CREME':
      return 'Crème';
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

String convertMedicineUsageUnit(String unit, bool plural) {
  switch (unit) {
    case 'CREME':
      return plural ? 'applications' : 'application';
    case 'POMMADE':
      return plural ? 'applications' : 'application';
    case 'GELULE':
      return plural ? 'gélules' : 'gélule';
    case 'COMPRIME':
      return plural ? 'comprimés' : 'comprimé';
    case 'GELE':
      return plural ? 'applications' : 'application';
    case 'SOLUTION_BUVABLE':
      return plural ? 'doses' : 'dose';
    case 'POUDRE':
      return plural ? 'sachets' : 'sachet';
    case 'SUPPOSITOIRE':
      return plural ? 'suppositoires' : 'suppositoire';
    case 'AMPOULE':
      return plural ? 'ampoules' : 'ampoule';
    case 'SUSPENSION_NASALE':
      return plural ? 'pulvérisations' : 'pulvérisation';
    case 'SPRAY':
      return plural ? 'pulvérisations' : 'pulvérisation';
    case 'COLLUTOIRE':
      return plural ? 'utilisations' : 'utilisation';
    case 'SHAMPOOING':
      return plural ? 'applications' : 'application';
    case 'SOLUTION_INJECTABLE':
      return plural ? 'doses' : 'dose';
    case 'COMPRIMER_EFERVESCENT':
      return plural ? 'comprimés effervescents' : 'comprimé effervescent';
    case 'GRANULER_EN_SACHET':
      return plural ? 'sachets' : 'sachet';
    case 'PASTILLE':
      return plural ? 'pastilles' : 'pastille';
    case 'SIROP':
      return plural ? 'doses' : 'dose';
    case 'COMPRIME_PELLICULE':
      return plural ? 'comprimés pelliculés' : 'comprimé pelliculé';
    case 'COMPRIME_ORODISPERSIBLE':
      return plural ? 'comprimés orodispersibles' : 'comprimé orodispersible';
    case 'COMPRIME_ENROBE':
      return plural ? 'comprimés enrobés' : 'comprimé enrobé';
    case 'CAPSULE_MOLLE':
      return plural ? 'capsules molles' : 'capsule molle';
    case 'SOLUTION_INHALATION':
      return plural ? 'inhalations' : 'inhalation';
    default:
      return plural ? 'comprimés' : 'comprimé';
  }
}

String periodConverter(String day) {
  switch (day) {
    case 'Jours':
      return 'JOUR';
    case 'Semaines':
      return 'SEMAINE';
    case 'Mois':
      return 'MOIS';
    case 'Années':
      return 'ANNEES';
    default:
      return 'jour';
  }
}