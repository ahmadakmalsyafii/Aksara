class ChapterModel {
  final String id;
  final String judulBab;
  final String konten;
  final int order;

  ChapterModel({required this.id, required this.judulBab, required this.konten,required this.order});

  factory ChapterModel.fromJson(String id, Map<String, dynamic> json) {
    return ChapterModel(
      id: id,
      judulBab: json['judulBab'],
      konten: json['konten'],
      order: json['order'],
    );
  }
}