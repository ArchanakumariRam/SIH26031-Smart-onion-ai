class DiseaseDiagnosis {
  final String id;
  final String name;
  final String localName;
  final String symptoms;
  final String organicTreatment;
  final String chemicalTreatment;
  final String preventiveTips;
  final String severity; // Low, Medium, High

  DiseaseDiagnosis({
    required this.id,
    required this.name,
    required this.localName,
    required this.symptoms,
    required this.organicTreatment,
    required this.chemicalTreatment,
    required this.preventiveTips,
    required this.severity,
  });
}
