class Document {
  final DateTime date;
  final String type;
  final String title;
  final String description;

  Document(
    this.date,
    this.type,
    this.title,
    this.description,
  );
}

class MedecinDocuments {
  final String medecin;
  late bool isExpanded;
  List<Document> documents;

  MedecinDocuments(this.medecin, this.documents, {this.isExpanded = false});
}
