import 'package:flutter/material.dart';

class BlockCategory extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"icon": 'assets/images/kategori_ipa.png' , "title": "IPA"},
    {"icon": 'assets/images/kategori_math.png', "title": "Mtk"},
    {"icon": 'assets/images/kategori_ips.png', "title": "IPS"},
    {"icon": 'assets/images/kategori_seni.png', "title": "Seni"},
    {"icon": 'assets/images/kategori_bing.png', "title": "B.Inggris"},
    {"icon": 'assets/images/kategori_bindo.png', "title": "B.Indo"},
    {"icon": 'assets/images/kategori_agama.png', "title": "Agama"},
    {"icon": 'assets/images/kategori_pkn.png', "title": "PKN"},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8, // lebih tinggi biar teks muat
        mainAxisSpacing: 16,   // jarak vertikal antar item
        crossAxisSpacing: 12,
      ),
        itemBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    categories[index]["icon"],
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Flexible(
                  child: Text(
                    categories[index]["title"],
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ),
            ],
          );
        },
    );
  }
}