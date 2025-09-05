class BookModel {
  final String id;
  final String judul;
  final String penerbit;
  final String tahun;
  final String kelas;
  final String coverUrl;
  final String penulis;
  final String isbn;
  final String deskripsi;
  final int halaman;
  final int harga;
  final List<String> kategori;

  BookModel({
    required this.id,
    required this.judul,
    required this.penerbit,
    required this.tahun,
    required this.kelas,
    required this.coverUrl,
    required this.harga,
    required this.deskripsi,
    required this.isbn,
    required this.halaman,
    required this.penulis,
    required this.kategori,

  });

  factory BookModel.fromJson(Map<String, dynamic> json, String id) {
    return BookModel(
      id: id,
      judul: json['judul'] ?? '',
      penerbit: json['penerbit'] ?? '',
      tahun: json['tahun']?.toString() ?? '',
      kelas: json['kelas'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      harga: json['harga'] ?? '',
      penulis: json['penulis'] ?? '',
      halaman: json['halaman'] ?? '',
      isbn: json['isbn'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      kategori: List<String>.from(json['kategori'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'penerbit': penerbit,
      'tahun': tahun,
      'kelas': kelas,
      'coverUrl': coverUrl,
      'harga':harga,
      'deskripsi': deskripsi,
      'isbn': isbn,
      'halaman': halaman,
      'penulis': penulis,
      'kategori': kategori,
    };
  }
}
