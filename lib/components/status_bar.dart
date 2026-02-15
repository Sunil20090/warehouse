import 'package:flutter/material.dart';
import 'package:warehouse/constants/theme_constant.dart';

class StatusBar extends StatefulWidget {
  List<dynamic> statuses;

  StatusBar({super.key, required this.statuses});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.statuses.asMap().entries.map((entry) {
          final index = entry.key;
          final status = entry.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (index != 0)
                Container(height: 5, width: 20, color: COLOR_PRIMARY),
              InkWell(
                onTapDown: (value) {
                  setState(() {
                    status['showing'] = true;
                  });
                },
                onTapUp: (details) {
                  setState(() {
                    status['showing'] = false;
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Badge(
                      label: Text(status['name']),
                      backgroundColor: COLOR_BASE_SUCCESS,
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
        // children: widget.statuses.map((status){
        //   return Row(
        //     children: [
        //       Badge(label: Text(status),),
        //       Container(height: 10, width: 20, color: COLOR_PRIMARY,),
        //     ],
        //   );
        // }).toList()
      ),
    );
  }
}
