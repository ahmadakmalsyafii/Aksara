class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? photoUrl;
  final String? kelas;
  final String? peminatan;
  final String? tanggalLahir;
  final List<String> bookmarks;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
    this.kelas,
    this.peminatan,
    this.tanggalLahir,
    this.bookmarks = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'photoUrl': photoUrl,
      'kelas': kelas,
      'peminatan': peminatan,
      'tanggalLahir': tanggalLahir,
      'bookmarks': bookmarks,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      kelas: map['kelas'],
      peminatan: map['peminatan'],
      tanggalLahir: map['tanggalLahir'],
      bookmarks: List<String>.from(map['bookmarks'] ?? []),
    );
  }

  UserModel copyWith({
    String? username,
    String? kelas,
    String? peminatan,
    String? tanggalLahir,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      bookmarks: bookmarks,
      username: username ?? this.username,
      kelas: kelas ?? this.kelas,
      peminatan: peminatan ?? this.peminatan,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}