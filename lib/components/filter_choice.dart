import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';

class FilterChoice extends StatefulWidget {
  final List<FilterModal> filterOptions;
  Function(List<FilterModal> appliedModels)? onChosen;
  FilterChoice({super.key, required this.filterOptions, this.onChosen});

  @override
  State<FilterChoice> createState() => _FilterChoiceState();
}

class _FilterChoiceState extends State<FilterChoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CONTENT_PADDING,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 10,
          children: widget.filterOptions.map((option) {
            return InkWell(
              onTap: () {
                setState(() {
                  option.isApplied = !option.isApplied;
                });
                if (widget.onChosen != null) {
                  widget.onChosen!(
                    widget.filterOptions
                        .where((filterModal) => filterModal.isApplied)
                        .toList(),
                  );
                }
              },
              child: Container(
                padding: CONTENT_PADDING,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(width: 0.5, color: COLOR_GREY),
                  color: option.isApplied ? COLOR_PRIMARY : COLOR_BASE,
                ),
                child: Row(
                  children: [
                    Text(
                      option.value,
                      style: getTextTheme(
                        color: option.isApplied ? COLOR_BASE : COLOR_BLACK,
                      ).titleSmall,
                    ),
                    Icon(Icons.arrow_drop_down,   color: option.isApplied ? COLOR_BASE : COLOR_BLACK,
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class FilterModal {
  final String value;
  bool isApplied;

  FilterModal({this.isApplied = false, required this.value});

  @override
  String toString() {
    return "value : $value, isApplied : $isApplied";
  }
}
