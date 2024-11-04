import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hintText;
  final int? maxLines;
  final TextEditingController controller;
  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter your $hintText';
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          )),
    );
  }
}
