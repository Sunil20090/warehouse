import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';

class FilterType extends StatefulWidget {
  final List<String> filters;
  
  final Function(String choosen) choosenValue;
  FilterType({super.key, required this.filters, required this.choosenValue});

  @override
  State<FilterType> createState() => _FilterTypeState();
}

class _FilterTypeState extends State<FilterType> {
  String _currentChoosenValue = '';

  @override
  void initState() {
    super.initState();
    _currentChoosenValue = (widget.filters.isNotEmpty) ? widget.filters[0] : '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: CONTENT_PADDING,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 4,
          children: [
            ...widget.filters.map((filter) {
              return FilterChip(
                selected: _currentChoosenValue == filter,
                label: Text(filter),
                onSelected: (value) {
                  setState(() {
                    _currentChoosenValue = filter;
                  });
                  widget.choosenValue(filter);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
