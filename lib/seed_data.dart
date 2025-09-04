import 'package:cloud_firestore/cloud_firestore.dart';

void seedBooks() async {
  final db = FirebaseFirestore.instance;

  await db.collection("books").doc("matematika_sma10").set({
    "title": "Matematika Kelas 10",
    "level": "SMA",
    "coverUrl": "https://example.com/matematika10.png",
    "description": "Buku matematika kurikulum 2013",
  });

  await db.collection("books").doc("matematika_sma10")
      .collection("chapters").doc("bab1").set({
    "title": "Pertidaksamaan",
    "content": "Pertidaksamaan adalah hubungan antara dua nilai yang tidak sama...",
    "order": 1,
  });

  await db.collection("books").doc("matematika_sma10")
      .collection("chapters").doc("bab2").set({
    "title": "Sistem Persamaan Linear",
    "content": "Sistem persamaan linear adalah sekumpulan persamaan linear...",
    "order": 2,
  });
}
