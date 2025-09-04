import 'package:flutter/material.dart';

class FilterList extends StatelessWidget {
  final String? selectedClass;
  final ValueChanged<String?> onSelected;

  const FilterList({
    super.key,
    required this.selectedClass,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["Kelas 10", "Kelas 11", "Kelas 12"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.map((label) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: selectedClass == label,
              onSelected: (val) => onSelected(val ? label : null),
            ),
          );
        }).toList(),
      ),
    );
  }
}
