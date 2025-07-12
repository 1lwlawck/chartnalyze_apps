import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';

class MultiSelectFloatingDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onChanged;

  const MultiSelectFloatingDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  State<MultiSelectFloatingDropdown> createState() =>
      _MultiSelectFloatingDropdownState();
}

class _MultiSelectFloatingDropdownState
    extends State<MultiSelectFloatingDropdown> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selectedItems);
  }

  void _toggleItem(String item) {
    setState(() {
      if (selected.contains(item)) {
        selected.remove(item);
      } else {
        selected.add(item);
      }
      widget.onChanged(selected);
    });
  }

  void _clearAll() {
    setState(() {
      selected.clear();
      widget.onChanged(selected);
    });
  }

  @override
  void didUpdateWidget(covariant MultiSelectFloatingDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems.toString() != oldWidget.selectedItems.toString()) {
      setState(() {
        selected = List.from(widget.selectedItems);
      });
    }
  }

  void _openDropdown() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Assets",
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearAll,
                    child: Text(
                      "Clear All",
                      style: GoogleFonts.aBeeZee(color: AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    children:
                        widget.items.map((item) {
                          final isSelected = selected.contains(item);
                          return ListTile(
                            title: Text(
                              item,
                              style: GoogleFonts.aBeeZee(
                                color:
                                    isSelected
                                        ? AppColors.primaryGreen
                                        : Colors.black,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryGreen,
                                    )
                                    : null,
                            onTap: () => _toggleItem(item),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeItem(String item) {
    setState(() {
      selected.remove(item);
      widget.onChanged(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDropdown,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryGreen, width: 1.5),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:
            selected.isEmpty
                ? Text(
                  "Select Assets",
                  style: GoogleFonts.aBeeZee(fontSize: 16),
                )
                : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      selected
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                border: Border.all(
                                  color: AppColors.primaryGreen,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item,
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: () => _removeItem(item),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
      ),
    );
  }
}
