import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';
import 'package:warehouse/utils/common_function.dart';

class CardWithBadge extends StatefulWidget {
  final String name;
  String? badge;
  Function? onCardClicked;
  IconData iconType;
  Color iconColor;

  CardWithBadge({
    super.key,
    required this.name,
    required this.iconType,
    this.badge,
    this.onCardClicked,
    this.iconColor = COLOR_PRIMARY,
  });

  @override
  State<CardWithBadge> createState() => _CardWithBadgeState();
}

class _CardWithBadgeState extends State<CardWithBadge> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          (widget.onCardClicked != null) ? widget.onCardClicked!() : null,
      child: Card(
        margin: CONTENT_PADDING,
        child: Padding(
          padding: CONTENT_PADDING * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.name, style: getTextTheme().headlineSmall),
              addVerticalSpace(),
              Icon(widget.iconType, size: 52, color: widget.iconColor),
              addVerticalSpace(),
              if (widget.badge != null)
                Badge(
                  backgroundColor: COLOR_SECONDARY,
                  padding: CONTENT_PADDING,
                  textStyle: getTextTheme().titleSmall,
                  label: Text('${widget.badge}'),
                ),

              // Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
