import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final controller;
  final String textLabel;
  final validator;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.textLabel,
    this.validator
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.textLabel,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color:Color(0xFF4149B3))
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color:Color(0xFF708090)),
        ),
      ),
      validator: widget.validator
    );
  }
}
