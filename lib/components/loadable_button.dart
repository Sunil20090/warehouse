import 'package:flutter/material.dart';
import 'package:warehouse/components/progress_circular.dart';
import 'package:warehouse/constants/theme_constant.dart';

class LoadableButton extends StatefulWidget {

  final String name;
  bool isLoading;
  Color textColor;
  Color backgroundColor;
  Function? onClicked;
  LoadableButton({super.key, this.isLoading= false, 
  required this.name, 
  this.onClicked,
  this.textColor = COLOR_BASE, 
  this.backgroundColor = COLOR_PRIMARY, });

  @override
  State<LoadableButton> createState() => _LoadableButtonState();
}

class _LoadableButtonState extends State<LoadableButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.isLoading
      ? (){
        if(widget.onClicked != null){
          widget.onClicked!();
        }
      } : null,
      child: Container(
        padding: CONTENT_PADDING,
        margin: CONTENT_PADDING,
        decoration: BoxDecoration(
          color: !widget.isLoading ? widget.backgroundColor : const Color.fromARGB(255, 52, 39, 236),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.isLoading
            ? ProgressCircular(color: widget.textColor, width: 20, height: 20,)
            : Text(widget.name, style: getTextTheme(color: widget.textColor).titleMedium,),
          ],
        )
      ),
    );
  }
}
