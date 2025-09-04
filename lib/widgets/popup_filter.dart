import 'package:flutter/material.dart';

class PopupFilter extends StatefulWidget {
  final String? selectedClass;
  const PopupFilter({super.key, this.selectedClass});

  @override
  State<PopupFilter> createState() => _PopupFilterState();
}

class _PopupFilterState extends State<PopupFilter> {
  String? selectedClass;

  final List<String> kelasList = [
    "Kelas 12",
    "Kelas 11",
    "Kelas 10",
    "Kelas 9",
    "Kelas 8",
    "Kelas 7",
    "Kelas 6",
    "Kelas 5",
  ];

  @override
  void initState() {
    super.initState();
    selectedClass = widget.selectedClass;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                "Filter Kategori",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Kelas",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: kelasList.length,
                  itemBuilder: (context, index) {
                    final label = kelasList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_month),
                        title: Text(label),
                        trailing: Radio<String>(
                          value: label,
                          groupValue: selectedClass,
                          onChanged: (val) =>
                              setState(() => selectedClass = val),
                        ),
                        onTap: () {
                          setState(() => selectedClass = label);
                        },
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => selectedClass = null);
                        Navigator.pop(context, null);
                      },
                      child: const Text("Hapus Filter"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, selectedClass),
                      child: const Text("Pasang", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
