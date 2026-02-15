import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FloatingLabelEditBox extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  String? hint;
  List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool hideText, clearable;
  final TextInputType? textInputType;
  final Widget? prefix;

  Function(String value)? onChange;

  FloatingLabelEditBox({
    super.key,
    this.controller,
    required this.labelText,
    this.maxLines = 1,
    this.hideText = false,
    this.hint,
    this.prefix,
    this.inputFormatters,
    this.onChange,
    this.clearable = false,
    this.textInputType,
  });

  @override
  State<FloatingLabelEditBox> createState() => _FloatingLabelEditBoxState();
}

class _FloatingLabelEditBoxState extends State<FloatingLabelEditBox> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      obscureText: widget.hideText,
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChange,

      decoration: InputDecoration(
        prefixIcon: widget.prefix,
        suffixIcon: (widget.clearable)
            ? IconButton(
                onPressed: () {
                  widget.controller!.text = "";
                  if (widget.onChange != null) {
                    widget.onChange!(widget.controller!.text);
                  }
                },
                icon: Icon(Icons.clear),
              )
            : null,

        hintText: widget.hint,

        label: Text(widget.labelText),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
