import 'dart:ffi';

import 'package:alak/constants/global_variables.dart';
import 'package:alak/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BelowAppbar extends StatelessWidget {
  const BelowAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black12, Colors.white30])),
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: RichText(
          text: TextSpan(
              text: 'Hello, ',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
              children: [
            TextSpan(
                text: user.name,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))
          ])),
    );
  }
}
