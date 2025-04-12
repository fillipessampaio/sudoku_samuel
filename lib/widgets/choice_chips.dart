import 'package:flutter/material.dart';

class CustomChoiceChips extends StatefulWidget {
  final List<String> options;
  final Function(String)? onSelected;

  const CustomChoiceChips({required this.options, this.onSelected, super.key});

  @override
  State<CustomChoiceChips> createState() => _CustomChoiceChipsState();
}

class _CustomChoiceChipsState extends State<CustomChoiceChips> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    if (widget.options.isNotEmpty) {
      selectedOption = widget.options.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children:
          widget.options.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color:
                        selectedOption == option
                            ? Colors.white
                            : Colors.black87,
                  ),
                ),
                selected: selectedOption == option,
                onSelected: (selected) {
                  setState(() {
                    selectedOption = selected ? option : null;
                  });
                  if (selected && widget.onSelected != null) {
                    widget.onSelected!(option);
                  }
                },
                selectedColor: Colors.teal,
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          }).toList(),
    );
  }
}
