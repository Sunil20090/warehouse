import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';

class CardWithBadge extends StatefulWidget {

  final String name;
  String? badge;
  Function? onCardClicked;
  CardWithBadge({super.key, required this.name, this.badge, this.onCardClicked});

  @override
  State<CardWithBadge> createState() => _CardWithBadgeState();
}

class _CardWithBadgeState extends State<CardWithBadge> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
            onTap: () => (widget.onCardClicked != null) ? widget.onCardClicked!() : null,
            child: Card(
              margin: CONTENT_PADDING,
              child: Padding(
                padding: CONTENT_PADDING * 2,
                child: Row(
                  children: [
                    Text(widget.name, style: getTextTheme().headlineSmall),
                    Spacer(),
                    Badge(
                        backgroundColor: COLOR_PRIMARY,
                        padding: CONTENT_PADDING,
                        textStyle: getTextTheme().titleSmall,
                        label: Text('${widget.badge}'),
                      ),
                      
                    Icon(Icons.arrow_right),
                  ],
                ),
              ),
            ),
          );
  }
}